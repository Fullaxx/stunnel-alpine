# ------------------------------------------------------------------------------
# Pull base image
FROM alpine:latest
LABEL author="Brett Kuskie <fullaxx@gmail.com>"

# ------------------------------------------------------------------------------
# Prepare the image
RUN apk update && apk add stunnel && rm /etc/stunnel/stunnel.conf
COPY app.sh /app/

# ------------------------------------------------------------------------------
# Add volumes
VOLUME /log

# ------------------------------------------------------------------------------
# Define runtime command
CMD ["/app/app.sh"]
