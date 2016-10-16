FROM eichptc/heroku:cli-latest

COPY src $HOME/workdir

WORKDIR $HOME/workdir
