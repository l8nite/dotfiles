# Docker
alias dps="docker ps"
alias dr="docker run --rm -it"
alias drm="docker rm"

# there are a few more docker-related functions below

# Git
alias ga="git add"
alias gc="git commit"
alias gco="git checkout"
alias gd="git diff -b"
alias gds="git diff --staged -b"
alias gi='git init && git commit --allow-empty -m "Empty commit"'
alias gs="git status"
alias gu="git unstage"

# Grep
alias ag="ack-grep --ignore-dir coverage --ignore-dir log --ignore-dir tmp"
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Ls
alias l='ls -CF'
alias la='ls -A'
alias ll='ls -alF'
alias ls='ls --color=auto'

# Ruby
alias cap="bundle exec cap"
alias guard="bundle exec guard"
alias rackup="bundle exec rackup"
alias rails="bundle exec rails"
alias rake="bundle exec rake"
alias rspec="bundle exec rspec"
alias rubocop="bundle exec rubocop"
alias sfn="bundle exec sfn"
alias spring="bundle exec spring"

# Tmux
alias tm="(tmux ls 2>/dev/null | grep -vq attached && tmux at) || tmux"

# Vim
alias v=vim
alias vi=vim

# Remove all exited containers except those with label=persistent
# Remove all dangling images
# Remove orphaned volumes
#
# Modified from:
# http://stackoverflow.com/questions/17236796/how-to-remove-old-docker-containers
#
# NOTE: This only works on Docker 1.9 due to the "docker volume ls" commands
function docker-cleanup {
  EXITED=($(docker ps -a -q -f status=exited))
  PERSISTENT=($(docker ps -a -q -f label=persistent))
  DANGLING_IMAGES=($(docker images -a -q -f dangling=true))
  DANGLING_VOLUMES=($(docker volume ls -qf dangling=true))

  # exclude any PERSISTENT container ids
  for i in "${PERSISTENT[@]}"; do
    EXITED=(${EXITED[@]//*$i*})
  done

  if [ "$1" == "--dry-run" ]; then
    echo "==> Would remove containers:"
    echo ${EXITED[@]}
    echo "==> And images:"
    echo ${DANGLING_IMAGES[@]}
    echo "==> And volumes:"
    echo ${DANGLING_VOLUMES[@]}
  else
    if [ -n "$EXITED" ]; then
      echo "Removing exited containers that don't have label=persistent..."
      docker rm ${EXITED[@]}
    else
      echo "No containers to remove."
    fi
    if [ -n "$DANGLING_IMAGES" ]; then
      echo "Removing dangling images..."
      docker rmi ${DANGLING_IMAGES[@]}
    else
      echo "No images to remove."
    fi
    if [ -n "$DANGLING_VOLUMES" ]; then
      echo "Removing dangling volumes..."
      docker volume rm ${DANGLING_VOLUMES[@]}
    else
      echo "No volumes to remove."
    fi
  fi
}

function docker-ip {
  if [[ -n "$@" ]]; then
    docker inspect --format '{{ .NetworkSettings.IPAddress }}' "$@"
  else
    docker ps -a | tail -n +2 | while read -a a; do
      name=${a[$((${#a[@]}-1))]}
      echo -ne "$name\t"
      docker inspect --format '{{ .NetworkSettings.IPAddress }}' $name
    done
  fi
}

# Automatically add completion for all aliases to commands having completion functions
function alias_completion {
    local namespace="alias_completion"

    # parse function based completion definitions, where capture group 2 => function and 3 => trigger
    local compl_regex='complete( +[^ ]+)* -F ([^ ]+) ("[^"]+"|[^ ]+)'
    # parse alias definitions, where capture group 1 => trigger, 2 => command, 3 => command arguments
    local alias_regex="alias ([^=]+)='(\"[^\"]+\"|[^ ]+)(( +[^ ]+)*)'"

    # create array of function completion triggers, keeping multi-word triggers together
    eval "local completions=($(complete -p | sed -Ene "/$compl_regex/s//'\3'/p"))"
    (( ${#completions[@]} == 0 )) && return 0

    # create temporary file for wrapper functions and completions
    rm -f "/tmp/${namespace}-*.tmp" # preliminary cleanup
    local tmp_file; tmp_file="$(mktemp "/tmp/${namespace}-${RANDOM}XXX.tmp")" || return 1

    local completion_loader; completion_loader="$(complete -p -D 2>/dev/null | sed -Ene 's/.* -F ([^ ]*).*/\1/p')"

    # read in "<alias> '<aliased command>' '<command args>'" lines from defined aliases
    local line; while read line; do
        eval "local alias_tokens; alias_tokens=($line)" 2>/dev/null || continue # some alias arg patterns cause an eval parse error
        local alias_name="${alias_tokens[0]}" alias_cmd="${alias_tokens[1]}" alias_args="${alias_tokens[2]# }"

        # skip aliases to pipes, boolean control structures and other command lists
        # (leveraging that eval errs out if $alias_args contains unquoted shell metacharacters)
        eval "local alias_arg_words; alias_arg_words=($alias_args)" 2>/dev/null || continue
        # avoid expanding wildcards
        read -a alias_arg_words <<< "$alias_args"

        # skip alias if there is no completion function triggered by the aliased command
        if [[ ! " ${completions[*]} " =~ " $alias_cmd " ]]; then
            if [[ -n "$completion_loader" ]]; then
                # force loading of completions for the aliased command
                eval "$completion_loader $alias_cmd"
                # 124 means completion loader was successful
                [[ $? -eq 124 ]] || continue
                completions+=($alias_cmd)
            else
                continue
            fi
        fi
        local new_completion="$(complete -p "$alias_cmd")"

        # create a wrapper inserting the alias arguments if any
        if [[ -n $alias_args ]]; then
            local compl_func="${new_completion/#* -F /}"; compl_func="${compl_func%% *}"
            # avoid recursive call loops by ignoring our own functions
            if [[ "${compl_func#_$namespace::}" == $compl_func ]]; then
                local compl_wrapper="_${namespace}::${alias_name}"
                    echo "function $compl_wrapper {
                        (( COMP_CWORD += ${#alias_arg_words[@]} ))
                        COMP_WORDS=($alias_cmd $alias_args \${COMP_WORDS[@]:1})
                        (( COMP_POINT -= \${#COMP_LINE} ))
                        COMP_LINE=\${COMP_LINE/$alias_name/$alias_cmd $alias_args}
                        (( COMP_POINT += \${#COMP_LINE} ))
                        $compl_func
                    }" >> "$tmp_file"
                    new_completion="${new_completion/ -F $compl_func / -F $compl_wrapper }"
            fi
        fi

        # replace completion trigger by alias
        new_completion="${new_completion% *} $alias_name"
        echo "$new_completion" >> "$tmp_file"
    done < <(alias -p | sed -Ene "s/$alias_regex/\1 '\2' '\3'/p")
    source "$tmp_file" && rm -f "$tmp_file"
}; alias_completion
