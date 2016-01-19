FROM debian:wheezy

RUN DEBIAN_FRONTEND=noninteractive \
    apt-get update &&\
    apt-get -y dist-upgrade

RUN DEBIAN_FRONTEND=noninteractive \
    apt-get install python-pip python-dev sudo aptitude -y

RUN apt-get clean
RUN pip install PyYAML jinja2 paramiko ansible

COPY LOCALHOST /tmp/ansible/LOCALHOST
COPY etc_host.yml /tmp/ansible/etc_host.yml

RUN ansible-playbook --verbose --diff -i /tmp/ansible/TESTHOST /tmp/ansible/etc_host.yml
