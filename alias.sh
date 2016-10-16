#!/bin/bash
    cat <<ALIAS
function f_docker_volumefrom() { \\
    if ! docker volume ls -q| grep "^\\(.*[\\/]\\)\\?\${1}-vol$" > /dev/null 2<&1; then \\
        echo "Creating volume ..."; \\
        docker create --name=\${1} -v \${1}-vol:\${3} alpine sh ; \\
        docker run -it --rm --volumes-from \${1} alpine chown \${2}:0 \${3}; \\
    fi; \\
}; \\
function f_heroku_clean() { \\
    docker rm -v -f \${1}; \\
}; \\
function f_heroku() { \\
    _v_name="heroku-\$(whoami)-\$(hostname)"; \\
    [[ ! -z "\\\$http_proxy" ]] && heroku_http_args="-e http_proxy=\\\${http_proxy}"; \\
    [[ ! -z "\\\$https_proxy" ]] && heroku_https_args="-e https_proxy=\\\${https_proxy}"; \\
    if [[ "\${1}" = "clean" ]]; then  \\
        f_heroku_clean "\${_v_name}"; \\
        return 0; \\
    fi; \\
    f_docker_volumefrom "\${_v_name}" "1000" "/data"; \\
    heroku_proxy_args="\${heroku_https_args} \${heroku_http_args}"; \\
    eval "docker run -it --volumes-from "\${_v_name}" --rm \${heroku_proxy_args} heroku \\\$@"; \\
}; \\
alias heroku='f_heroku';
ALIAS
