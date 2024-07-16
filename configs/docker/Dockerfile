FROM alpine
RUN apk add --no-cache --upgrade curl
ADD init-script.sh .
RUN chmod +x init-script.sh
CMD ["/init-script.sh"]
