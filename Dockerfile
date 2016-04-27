FROM taf7lwappqystqp4u7wjsqkdc7dquw/heavytombstone
USER root
VOLUME /var/private
ENV GIT_EMAIL="emory.merryman@gmail.com" GIT_NAME="Emory Merryman" ORGANIZATION="organization" REPOSITORY="repository"
RUN dnf update --assumeyes && dnf install --assumeyes emacs bash-completion git && dnf update --assumeyes && dnf clean all && mkdir /var/workspace && chown ${LUSER}:${LUSER} /var/workspace
VOLUME /var/workspace
USER ${LUSER}
RUN mkdir /home/${LUSER}/.ssh && chmod 0700 /home/${LUSER}/.ssh && echo -e "Host github.com\nUser git\nStrictHostKeyChecking no" > /home/${LUSER}/.ssh/config && chmod 0600 /home/${LUSER}/.ssh/config 
WORKDIR /var/workspace
CMD cp /var/private/id_rsa /home/${LUSER}/.ssh && chmod 0600 /home/${LUSER}/.ssh/id_rsa && git config --global user.email ${GIT_EMAIL} && git config --global user.name ${GIT_NAME} && if [ ! -d .git ]; then git init && git remote add origin git@github.com:${ORGANIZATION}/${REPOSITORY}.git && git fetch origin master && git checkout master && /usr/bin/bash && git push --follow-tags origin master