# using non base tag images as npm install is required
# latest        – 54.26 MB (npm 3.10.10)
# 7, 7.3, 7.3.0 – 54.26 MB (npm 3.10.10)
FROM mhart/alpine-node:6
# 6, 6.9, 6.9.2 – 49.65 MB (npm 3.10.10)
# 4, 4.7, 4.7.0 – 36.82 MB (npm 2.15.11)

RUN apk add --no-cache htop bash curl vim nano figlet
RUN npm install pm2 -g --depth=0
# setup bash terminal
RUN curl https://raw.githubusercontent.com/gitnooji/nj-docker-support/master/.bashrc > /root/.bashrc

# creates folder `/server` and uses it as the current working directory
# for all docker commands operating on the container.
WORKDIR /server

# if you want the current filesystem contents statically loaded into
# the container, enable the COPY command below. you can still mount your
# local filesystem over the static contents of the `/server` folder
# COPY . .

# If you have native dependencies, you'll need extra tools
# RUN apk add --no-cache make gcc g++ python

# install/config if needed
# RUN npm install

EXPOSE 3001 3002 8000 8001 8002 8080 8181
CMD ["npm", "start"]
