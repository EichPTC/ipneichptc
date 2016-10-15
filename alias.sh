#!/bin/bash
    cat <<ALIAS
function f_heroku() { \\
    [[ ! -z "\\\$http_proxy" ]] && heroku_http_args="-e http_proxy=\\\${http_proxy}"; \\
    [[ ! -z "\\\$https_proxy" ]] && heroku_https_args="-e https_proxy=\\\${https_proxy}"; \\
    heroku_proxy_args="\${heroku_https_args} \${heroku_http_args}"; \\
    eval "docker run -it --rm \${heroku_proxy_args} heroku \\\$@"; \\
}; \\
alias heroku='f_heroku';
ALIAS
