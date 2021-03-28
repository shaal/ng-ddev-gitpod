FROM gitpod/workspace-full
SHELL ["/bin/bash", "-c"]

RUN sudo apt-get -qq update
# Install Projector 
RUN sudo apt-get -qq install -y python3 python3-pip libxext6 libxrender1 libxtst6 libfreetype6 libxi6
RUN pip3 install projector-installer
# Install PhpStorm
RUN mkdir -p ~/.projector/configs  # Prevents projector install from asking for the license acceptance
RUN projector install 'PhpStorm 2020.3.3' --no-auto-run

# Install ddev
RUN brew update && brew install drud/ddev/ddev

RUN composer install
RUN sudo docker-up &

# Wait for docker to come up before running ddev
RUN brew upgrade ddev
RUN mkcert -install

      # Wait for docker to come up before doing gitpod setup (gitpod-setup requires docker)
RUN |
    while ! docker ps 2>/dev/null; do
      sleep 1
    done
    .ddev/gitpod-setup-ddev.sh
