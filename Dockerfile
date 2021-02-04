FROM centos:6
LABEL maintainer="Jeff Geerling"

# Install Ansible and other requirements.
RUN REPODIR="/etc/yum.repos.d" \
 && for i in CentOS-Debuginfo CentOS-Vault; do mv $REPODIR/$i.repo $REPODIR/$i.repo.disable ; done \
 && sed -i -e 's/^#baseurl=http:\/\/mirror.centos.org/baseurl=http:\/\/vault.centos.org/'  /etc/yum.repos.d/CentOS*.repo \
 && yum makecache fast \
 && yum -y install deltarpm epel-release \
 && sed -i -e 's/^#baseurl=http:\/\/download.fedoraproject.org\/pub\//baseurl=http:\/\/archives.fedoraproject.org\/pub\/archive\//'  /etc/yum.repos.d/epel*.repo \
 && sed -i -e 's/^mirrorlist=/#mirrorlist=/' /etc/yum.repos.d/epel*.repo \
 && yum -y update \
 && yum -y install \
      ansible \
      sudo \
      which \
      initscripts \
      python-urllib3 \
      pyOpenSSL \
      python2-ndg_httpsclient \
      python-pyasn1 \
 && yum clean all

# Disable requiretty.
RUN sed -i -e 's/^\(Defaults\s*requiretty\)/#--- \1/'  /etc/sudoers

# Install Ansible inventory file.
RUN mkdir -p /etc/ansible
RUN echo -e '[local]\nlocalhost ansible_connection=local' > /etc/ansible/hosts

CMD ["/sbin/init"]
