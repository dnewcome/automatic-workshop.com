FROM ghost:5-alpine

USER root
WORKDIR /var/lib/ghost

# Install the S3-compatible storage adapter for DO Spaces
# Creates content/adapters/storage/s3/ with adapter + dependencies
RUN mkdir -p content/adapters/storage/s3 \
    && cd content/adapters/storage/s3 \
    && npm init -y \
    && npm install ghost-storage-adapter-s3 \
    && printf 'module.exports = require("ghost-storage-adapter-s3");\n' > index.js \
    && chown -R node:node content/adapters

# Copy the custom theme into the image
COPY --chown=node:node . content/themes/automatic-workshop

WORKDIR /var/lib/ghost
USER node
