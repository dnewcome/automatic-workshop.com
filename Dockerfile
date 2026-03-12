FROM ghost:5-alpine

USER root

# Install the S3-compatible storage adapter for DO Spaces
WORKDIR /var/lib/ghost/content/adapters/storage/s3
RUN npm init -y \
    && npm install ghost-storage-adapter-s3 \
    && printf 'module.exports = require("ghost-storage-adapter-s3");\n' > index.js

WORKDIR /var/lib/ghost
RUN chown -R node:node content/adapters

# Copy the custom theme into the image
COPY --chown=node:node . content/themes/automatic-workshop

USER node
