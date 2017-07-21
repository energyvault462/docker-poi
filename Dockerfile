FROM energyvault462/rvm

MAINTAINER Brent Johnson <brentj433@gmail.com>

ARG BUILD_DATE
ARG BUILD_NUMBER
ARG VERSION

LABEL org.metadata.build-date=$BUILD_DATE \
	   org.metadata.version=$VERSION.$BUILD_NUMBER \
	   org.metadata.name="Running version of Plex Offline Indexer" \
	   org.metadata.description="This is deployed to production" \
	   org.metadata.url="https://github.com/energyvault462/docker-poi" \
	   org.metadata.vcs-url="https://github.com/energyvault462/docker-poi"

RUN apt-get update && apt-get install git -y

RUN useradd -u 2002 -ms /bin/zsh mce && \
	 echo "mce ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Install versions of Ruby and configs
RUN /usr/local/rvm/bin/rvm install 2.3.0 && \
         /usr/local/rvm/bin/rvm rvmrc warning ignore allGemfiles

USER root
RUN chown -R mce /home/mce && \
         chown -R mce /usr/local/rvm

USER mce
ENV USER mce
ENV PATH $HOME:$PATH
ENV DOCKER true
ENV PATH /usr/local/rvm/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
RUN /bin/bash -l -c "rvm requirements"
RUN /bin/bash -l -c "gem install bundler --no-ri --no-rdoc"


ARG FORCE_NEW_BUILD=unknown
RUN FORCE_NEW_BUILD=${GIT_PULL_TIME} 
RUN git clone https://github.com/energyvault462/plex-offline-indexer.git $HOME/plex-offline-indexer
RUN cd $HOME/plex-offline-indexer && /bin/bash -l -c "rvm requirements"
RUN cd $HOME/plex-offline-indexer && /bin/bash -l -c "gem install bundler --no-ri --no-rdoc"


WORKDIR  /home/mce
CMD ["/bin/bash"]




