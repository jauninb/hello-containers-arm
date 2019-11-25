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

FROM arm32v7/node:12-alpine

# copy qemu - https://ownyourbits.com/2018/06/27/running-and-building-arm-docker-containers-in-x86/
COPY qemu-arm-static /usr/bin

# Install the application
ADD package.json /app/package.json
RUN cd /app && npm install
COPY app.js /app/app.js

WORKDIR /app

ENV PORT 8080
EXPOSE 8080

# Define command to run the application when the container starts
CMD ["node", "app.js"]
