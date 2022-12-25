# Set the required version of Alpine Linux as build argument
ARG AL_VERSION=3.17.0

# Use a pinned version of the base image to ensure that the build is reproducible
FROM alpine:${AL_VERSION}

# Set the version of Pocketbase as environment variable 
ENV PB_VERSION=0.10.3

# Add labels to the image
LABEL org.opencontainers.image.source="https://github.com/AliSajid/pbfly"
LABEL org.opencontainers.image.description="This is a small image that allows you to run PocketBase in Docker or other container environments."
LABEL org.opencontainers.image.licenses="MIT"
LABEL org.opencontainers.image.authors="Ali Sajid Imami"
LABEL org.opencontainers.image.title="pbfly"
LABEL org.opencontainers.image.url="https://AliSajid.github.io/pbfly"
LABEL org.opencontainers.image.version="al-v${AL_VERSION}_pb-v${PB_VERSION}"

# Install required packages
RUN apk add --no-cache \
    unzip \
    openssh

# Set the version of Pocketbase as an environment variable
#ENV PB_VERSION_ENV=${PB_VERSION}

# Download and install Pocketbase
ADD https://github.com/pocketbase/pocketbase/releases/download/v${PB_VERSION}/pocketbase_${PB_VERSION}_linux_amd64.zip /tmp/pb.zip
RUN unzip /tmp/pb.zip -d /pbfly

# Set the working directory
WORKDIR /pbfly

# Set the output port
ENV PORT=8080

COPY pbfly_public pbfly_public

# Expose the output port
EXPOSE 8080

# Start Pocketbase
CMD ["./pocketbase", "serve", "--http=0.0.0.0:8080", "--dir=/pbfly/pbfly_data", "--publicDir=/pbfly/pbfly_public"]