FROM openshift/base-centos7:latest

RUN echo $'[gocd] \n\
name     = GoCD YUM Repository\n\
baseurl  = https://download.gocd.io\n\
enabled  = 1\n\
gpgcheck = 1\n\
gpgkey   = https://download.gocd.io/GOCD-GPG-KEY.asc' > /etc/yum.repos.d/gocd.repo && \
yum install -y --setopt=tsflags=nodocs java-1.8.0-openjdk git go-agent && yum clean all -y

# force encoding
ENV LANG=en_US.utf8

# Install openshift cli
RUN set -o pipefail && curl -L https://github.com/openshift/origin/releases/download/v3.6.0/openshift-origin-client-tools-v3.6.0-c4dd4cf-linux-64bit.tar.gz| \
    tar -zx && \
    mv openshift*/oc /usr/local/bin && \
    rm -rf openshift-origin-client-tools-*

ENV PATH "${SONAR_SCANNER_CLI_HOME}/bin:${PATH}"

# Install nodejs
RUN set -x \
    && rpm -ivh https://kojipkgs.fedoraproject.org//packages/http-parser/2.7.1/3.el7/x86_64/http-parser-2.7.1-3.el7.x86_64.rpm \
    && wget https://dl.yarnpkg.com/rpm/yarn.repo -O /etc/yum.repos.d/yarn.repo \
    && yum install -y --setopt=tsflags=nodocs epel-release \
    && yum install -y --setopt=tsflags=nodocs nodejs npm yarn \
    && yum update openssl

RUN yum clean all -y

ADD start.sh /start.sh

# Set permissions
RUN chgrp -R 0 /opt/app-root/src /var/lib/go-agent /usr/share/go-agent /var/log/go-agent /etc/default/go-agent /var/run/go-agent /start.sh && \
    chmod -R g+rw /opt/app-root/src /var/lib/go-agent /usr/share/go-agent /var/log/go-agent /etc/default/go-agent /var/run/go-agent /start.sh

WORKDIR /usr/share/go-agent
ENV DAEMON=N PRODUCTION_MODE=N USER_NAME=go

CMD ["/start.sh"]
