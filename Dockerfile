FROM ruby:2.3.0
RUN apt-get update && apt-get install -y build-essential libpq-dev
RUN useradd -u 2002 -ms /bin/zsh mce
RUN chown -R mce /home/mce

USER mce

ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/bin/ruby/:/home/app/.rbenv/bin:/home/app/.rbenv/shims:/home/app/.rbenv/plugins
ARG FORCE_NEW_BUILD=unknown
RUN FORCE_NEW_BUILD=${GIT_PULL_TIME}
RUN git clone https://github.com/energyvault462/plex-offline-indexer.git /home/mce/plex-offline-indexer
WORKDIR /home/mce/plex-offline-indexer
RUN bundle install
ENTRYPOINT ["ruby", "updatePlexSeries.rb"]
