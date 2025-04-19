FROM alpine:latest

RUN apk add --no-cache openssl nginx bash

COPY generate_cert.sh /generate_cert.sh
RUN chmod +x /generate_cert.sh && /generate_cert.sh

COPY nginx.conf /etc/nginx/nginx.conf
COPY html/ /usr/share/nginx/html
COPY ssl/ /etc/nginx/ssl

EXPOSE 8080
EXPOSE 4343

CMD ["nginx", "-g", "daemon off;"]
