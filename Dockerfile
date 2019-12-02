#  Copyright 2019 IBM
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
FROM multiarch/qemu-user-static as qemu

FROM arm32v7/node:12-alpine

# copy qemu arm emulator in the docker image layer as docker build process will required it
# - inspired from https://ownyourbits.com/2018/06/27/running-and-building-arm-docker-containers-in-x86/
WORKDIR /qemu/bin
COPY --from=qemu /usr/bin/qemu-arm-static /qemu/bin
WORKDIR /

# Install the application
ADD package.json /app/package.json
RUN cd /app && npm install
COPY app.js /app/app.js

# Support to for arbitrary UserIds
# https://docs.openshift.com/container-platform/3.11/creating_images/guidelines.html#openshift-specific-guidelines
RUN chmod -R u+x /app && \
    chgrp -R 0 /app && \
    chmod -R g=u /app /etc/passwd

USER 1001

WORKDIR /app

ENV PORT 8080
EXPOSE 8080

# Remove the qemu bin for production only
# RUN rm -r -f /qemu

# Define command to run the application when the container starts
CMD ["node", "app.js"]
