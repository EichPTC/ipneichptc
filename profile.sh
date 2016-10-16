#!/bin/bash

#
# lets show some usage
#
function do_usage()
{
    echo "You found the heroku-cli container $(heroku --version)"
    echo "This container has the following options:"
    echo
    echo "run   - (default) run some heroku cli command"
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

#
# run the heroku cli
#
function do_run()
{
    heroku $@
}

#
# intialize persistent data
#
function do_init()
{
    if [ -d /data ]; then
        # remove whats there if it exist in /data
        [ -d /data/config ] && [ -d $HOME/.config ] && [ ! -L $HOME/.config ] && \
            rm -rf $HOME/.config
        [ -f /data/netrc ] && [ -f $HOME/netrc ] && [ ! -L $HOME/.netrc ] && \
            rm -f $HOME/.netrc

        # move the directorys and files if theyre fond and not links
        [ -d $HOME/.config ] && [ ! -L $HOME/.config ] && \
            mv $HOME/.config /data/config
        [ -f $HOME/.netrc ] && [ ! -L $HOME/.netrc ] && \
            mv $HOME/.netrc /data/netrc

        # create the links if the /data folder exist
        [ ! -L $HOME/.config ] && \
            ln -s /data/config $HOME/.config
        [ ! -L $HOME/.netrc ] && \
            ln -s /data/netrc $HOME/.netrc

        # create the destinations if they dont exist
        [ ! -d /data/config ] && mkdir -p /data/config
        if [ ! -f /data/netrc ] ; then
            touch /data/netrc
            chmod 0600 /data/netrc
        fi
    fi
}

#
# shift by 1
function f_shift() {
    shift
    echo $@
}


if [ ! -z "$DEBUG" ] ; then
    set -x -v
    echo $ENTRYPOINT_CMD
fi

do_init
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
        run)
            FOO=$(f_shift $FOO)
            shift
            do_run $(f_shift $ENTRYPOINT_CMD)
            exit $?;;
        *)
            do_run $ENTRYPOINT_CMD
            exit $?;;
    esac
done


