## Dockerfile1

```bash
FROM centos:7
MAINTAINER Aliia Moiseeva <alia.vm01@gmail.com>

RUN yum install -y java-1.8.0-openjdk-devel \
    openssh-server \
    openssh-clients \
    rsync \
    ssh \
    wget

RUN wget https://archive.apache.org/dist/hadoop/common/hadoop-3.1.2/hadoop-3.1.2.tar.gz && \
    tar -zxf hadoop-3.1.2.tar.gz -C /opt/ && \
    rm hadoop-3.1.2.tar.gz

RUN mkdir -p /usr/local/hadoop/ && \
    mkdir /opt/mount{1,2} && \
    ln -s /opt/hadoop-3.1.2 /usr/local/hadoop/current && \
    \
    groupadd -g 3120 hadoop && \
    useradd -g 3120 hadoop && \
    useradd -g 3120 yarn && \
    useradd -g 3120 hdfs && \
    \
    mkdir /opt/mount{1,2}/datenode-dir && \
    chown hdfs:hadoop /opt/mount{1,2}/datenode-dir && \
    \
    mkdir /opt/mount{1,2}/nodemanager-lo{cal-dir,g-dir} && \
    chown yarn:hadoop /opt/mount{1,2}/nodemanager-lo{cal,g}-dir && \
    \
    ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa && \
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys && \
    chmod 0600 ~/.ssh/authorized_keys

VOLUME [ "/opt/mount1/", "/opt/mount2/" ]

RUN wget https://gist.githubusercontent.com/rdaadr/2f42f248f02aeda18105805493bb0e9b/raw/6303e424373b3459bcf3720b253c01373666fe7c/hadoop-env.sh && \
    sed -Ei 's#%PATH_TO_OPENJDK8_INSTALLATION%#/usr/lib/jvm/java-1.8.0-openjdk/#g' hadoop-env.sh && \
    sed -Ei 's#%PATH_TO_HADOOP_INSTALLATION#/usr/local/hadoop/current#g' hadoop-env.sh && \
    sed -Ei 's#%HADOOP_HEAP_SIZE%#512M#g' hadoop-env.sh && \
    \
    wget https://gist.githubusercontent.com/rdaadr/64b9abd1700e15f04147ea48bc72b3c7/raw/2d416bf137cba81b107508153621ee548e2c877d/core-site.xml && \
    sed -Ei 's#%HDFS_NAMENODE_HOSTNAME%#hadoop-namenode#g' core-site.xml && \
    \
    wget https://gist.githubusercontent.com/rdaadr/2bedf24fd2721bad276e416b57d63e38/raw/640ee95adafa31a70869b54767104b826964af48/hdfs-site.xml && \
    sed -Ei 's#%NAMENODE_DIRS%#/opt/mount1/namenode-dir/,/opt/mount2/namenode-dir/#g' hdfs-site.xml && \
    sed -Ei 's#%DATANODE_DIRS%#/opt/mount1/datenode-dir/,/opt/mount2/datenode-dir/#g' hdfs-site.xml && \
    \
    wget https://gist.githubusercontent.com/Stupnikov-NA/ba87c0072cd51aa85c9ee6334cc99158/raw/bda0f760878d97213196d634be9b53a089e796ea/yarn-site.xml && \
    sed -Ei 's#%YARN_RESOURCE_MANAGER_HOSTNAME%#hadoop-namenode#g' yarn-site.xml && \
    sed -Ei 's#%NODE_MANAGER_LOCAL_DIR%#/opt/mount1/nodemanager-local-dir/,/opt/mount2/nodemanager-local-dir/#g' yarn-site.xml && \
    sed -Ei 's#%NODE_MANAGER_LOG_DIR%#/opt/mount1/nodemanager-log-dir/,/opt/mount2/nodemanager-log-dir/#g' yarn-site.xml && \
    \
    chown yarn:1002 {hadoop-env.sh,core-site.xml,hdfs-site.xml,yarn-site.xml} && \
    mv {hadoop-env.sh,core-site.xml,hdfs-site.xml,yarn-site.xml} /usr/local/hadoop/current/etc/hadoop/ && \
    echo -e '#Hadoop variables\nexport HADOOP_HOME=/usr/local/hadoop/current/hadoop-3.1.2' >> /etc/profile

COPY run2.sh /root/run2.sh

RUN chmod u+x /root/run2.sh && \
    mkdir /usr/local/hadoop/current/logs && \
    chmod g+w /usr/local/hadoop/current/logs && \
    chown hadoop:hadoop /usr/local/hadoop/current/logs

EXPOSE 8042 9864
ENTRYPOINT /root/run2.sh
CMD /bin/bash
```
