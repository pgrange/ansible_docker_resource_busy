FROM debian:wheezy

RUN DEBIAN_FRONTEND=noninteractive \
    apt-get update &&\
    apt-get -y dist-upgrade

RUN DEBIAN_FRONTEND=noninteractive \
    apt-get install python-pip python-dev sudo aptitude git libffi-dev libssl-dev -y

RUN apt-get clean
RUN pip install PyYAML jinja2 paramiko six

#install a fresh new ansible version from source
RUN git clone https://github.com/ansible/ansible.git
RUN cd ansible && git submodule update --init
RUN cd ansible/lib/ansible/modules/core && git checkout devel && git pull --rebase
RUN cd ansible/lib/ansible/modules/extras && git checkout devel && git pull --rebase
RUN cd ansible && make install

COPY LOCALHOST /tmp/ansible/LOCALHOST
COPY etc_host.yml /tmp/ansible/etc_host.yml

RUN ansible-playbook --verbose --diff -i /tmp/ansible/TESTHOST /tmp/ansible/etc_host.yml
