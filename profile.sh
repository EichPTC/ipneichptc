#!/bin/bash

#
# lets show some usage
#
function do_usage()
{
    echo "You found the heroku-cli container $(heroku --version)"
    echo "This container has the following options:"
    echo
    echo "shell - starts a command prompt where you can run heroku"
    echo "-h|--help|help - prints this help"
}

#
# lets run a shell
#
function do_shell()
{
    set -o vi
    . /etc/profile.d/rvm.sh
    rvm use $RUBY_VERSION --default && \
    ruby --version && \
    gem --version
}

#
# generate an alias for the current running container
#
function do_alias()
{
    /opt/alias.sh
echo '#; \\'
echo '#  eval "$(docker run -it --rm heroku alias|dos2unix)"';
}

#if [ ! -z "$DEBUG" ] ; then
#    set -x -v
#    echo $ENTRYPOINT_CMD
#fi

for opt in $ENTRYPOINT_CMD; do
    case "$opt" in
        -h|--help|help)
            do_usage
            exit 3;;
        shell)
            do_shell;;
        alias)
            do_alias
            exit 0;;
        *)
            echo "No command found, try help or -h"
            exit 1;;
    esac
done


