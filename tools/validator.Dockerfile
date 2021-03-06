FROM ubuntu:14.04

RUN apt-get clean \
    && apt-get update \
    # Install common packages
    && apt-get install -y software-properties-common apt-transport-https ca-certificates wget \
    # Install Ansible and Git
    && apt-add-repository ppa:ansible/ansible \
    && apt-get update \
    && apt-get install -y ansible git \
    # Add the localhost to the Ansible's hosts
    && echo 'localhost ansible_connection=local' >> /etc/ansible/hosts \
    # Pre-install python 3.4 and pip3 to speed-up the next steps
    && apt-get install -y python3.4 python3.pip python3-pycparser\
    && apt-get install -y build-essential libssl-dev libffi-dev python-dev \
    && apt-get clean \
    && echo 'Done'

COPY ansible /ansible
COPY ./dist/sonata_cli-*-py3-*.whl /tmp/

RUN cd /ansible \
    # Start the basic Ansible setup
    && ansible-playbook install.yml \
    && echo 'Installing son-cli' \
    # Install the son-cli package from a local wheel
    && pip3 install /tmp/sonata_cli-*-py3-*.whl \
    && echo 'Done, installed son-cli'

# Flag to know if we are running in a docker container or not
ENV SON_CLI_IN_DOCKER 1

# Run validator service
CMD ["son-validate-api", "--host", "0.0.0.0", "--port", "5001", "--debug"]
