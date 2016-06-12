FROM cassandra:latest
MAINTAINER Ivan Cuesta 

ADD files/create_table.cql /root/create_table.cql
ADD files/start.sh /root/start.sh

RUN chmod +rx /root/create_table.cql
RUN chmod +rx /root/start.sh
RUN apt-get update && apt-get -y install curl

ENTRYPOINT ["/root/start.sh"]
