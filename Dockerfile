FROM ruby:3.3.0-slim-bookworm AS jekyll-client

RUN apt update && apt install -y --no-install-recommends \
    build-essential \
    zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

#RUN gem update --system && gem install bundler -v 2.5.6 && gem cleanup
ARG R_USER=webuser
ARG R_UID=2016
ARG R_GROUP=webgroup
ARG R_GID=1016
ARG JK_DOCS=/docs

RUN addgroup --gid $R_GID $R_GROUP && adduser www-data $R_GROUP && \
    adduser --uid $R_UID --gid $R_GID --disabled-password \
        --quiet --shell /bin/bash --gecos "" $R_USER && \
    bash -c 'echo -e "umask 002\nexport GEM_HOME=\$HOME/gems\nexport PATH=\$HOME/gems/bin:\$PATH" >> /home/$R_USER/.bashrc'

COPY docker-entrypoint-client.sh /usr/local/bin/

COPY docs-skel $JK_DOCS
RUN chown -R $R_UID:$R_GID /docs && chmod g+s $JK_DOCS

USER $R_USER
WORKDIR $JK_DOCS
#RUN su - -c "GEM_HOME=~/gems gem install bundler -v 2.5.6" webuser
#RUN su - -c "cd /docs; GEM_HOME=~/gems bundle install" webuser
RUN GEM_HOME=~/gems gem install bundler -v 2.5.6
RUN GEM_HOME=~/gems bundle install

ENTRYPOINT ["docker-entrypoint-client.sh"]
CMD ["tail", "-f", "/proc/self/fd/2"]

# build from the image we just built with different metadata
FROM jekyll-client AS jekyll-server
EXPOSE 4000
VOLUME $JK_DOCS
COPY docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT [ "docker-entrypoint.sh" ]

CMD [ "bundle", "exec", "jekyll", "serve", "--force_polling", "-H", "0.0.0.0", "-P", "4000" ]