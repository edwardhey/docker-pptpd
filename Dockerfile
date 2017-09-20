FROM debian:stretch

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update --fix-missing && apt-get install -y pptpd iptables

RUN echo "localip 10.0.0.1" >> /etc/pptpd.conf
RUN echo "remoteip 10.0.0.100-200" >> /etc/pptpd.conf

RUN sed -i -e 's/#ms-dns 10.0.0.1/ms-dns 208.67.222.222/g' /etc/ppp/pptpd-options
RUN sed -i -e 's/#ms-dns 10.0.0.2/ms-dns 208.67.220.220/g' /etc/ppp/pptpd-options

ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["pptpd", "--fg"]
