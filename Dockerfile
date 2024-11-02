FROM jenkins/inbound-agent:alpine-jdk21 as jnlp

FROM node:20-alpine

RUN apk -U add openjdk21-jre git curl bash
RUN apk -U add --no-cache bash zip make gcc g++ python3 linux-headers paxctl gnupg
RUN apk -U add --no-cache openssl libc6-compat curl git chromium chromium-chromedriver xvfb

ENV CHROME_BIN /usr/bin/chromium-browser

RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
RUN . "/root/.nvm/nvm.sh"

RUN npm install -g pnpm

COPY --from=jnlp /usr/local/bin/jenkins-agent /usr/local/bin/jenkins-agent
COPY --from=jnlp /usr/share/jenkins/agent.jar /usr/share/jenkins/agent.jar

ENTRYPOINT ["/usr/local/bin/jenkins-agent"]
