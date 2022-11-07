# Use a pinned version of the base image to ensure that the build is reproducible
FROM alpine:3.16.2

# Set the required version of Pocketbase as an argument
ARG PB_VERSION=0.7.9

# Install required packages
RUN apk add --no-cache \
    unzip \
    openssh

# Download and install Pocketbase
ADD https://github.com/pocketbase/pocketbase/releases/download/v${PB_VERSION}/pocketbase_${PB_VERSION}_linux_amd64.zip /tmp/pb.zip
RUN unzip /tmp/pb.zip -d /pbfly

# Set the working directory
WORKDIR /pbfly

# Set the output port
ENV PORT=8080

COPY pbfly_public .

# Expose the output port
EXPOSE 8080

# Start Pocketbase
CMD ["./pocketbase", "serve", "--http=0.0.0.0:8080", "--dir=pblfy_data", "--publicDir=pbfly_public"]