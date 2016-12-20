FROM mhart/alpine-node:6

RUN apk add --no-cache htop bash curl
RUN npm install pm2 -g --depth=0
RUN curl https://raw.githubusercontent.com/gitnooji/nj-docker-support/master/.bashrc > /root/.bashrc

WORKDIR /server
COPY . .

# If you have native dependencies, you'll need extra tools
# RUN apk add --no-cache make gcc g++ python

# If you need npm, don't use a base tag
RUN npm install

EXPOSE 3001 3002 8000 8001 8002 8080 8181
CMD ["npm", "start"]
