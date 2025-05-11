# ------------------------------------------------------------------------------
# Pull base image
FROM alpine
LABEL author="Brett Kuskie <fullaxx@gmail.com>"

# ------------------------------------------------------------------------------
# Prepare the image
RUN apk update && apk add bash stunnel && rm /etc/stunnel/stunnel.conf
COPY app.sh /app/

# ------------------------------------------------------------------------------
# Define runtime command
CMD ["/app/app.sh"]
