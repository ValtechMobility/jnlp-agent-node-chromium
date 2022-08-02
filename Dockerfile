FROM jenkins/inbound-agent:alpine as jnlp

FROM node:10.16.0-alpine

RUN apk -U add openjdk8-jre git curl bash
RUN apk -U add --no-cache bash zip make gcc g++ python linux-headers paxctl gnupg
RUN apk -U add --no-cache openssl libc6-compat curl git chromium chromium-chromedriver xvfb

ENV CHROME_BIN /usr/bin/chromium-browser

RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
RUN . "/root/.nvm/nvm.sh"

COPY --from=jnlp /usr/local/bin/jenkins-agent /usr/local/bin/jenkins-agent
COPY --from=jnlp /usr/share/jenkins/agent.jar /usr/share/jenkins/agent.jar

ENTRYPOINT ["/usr/local/bin/jenkins-agent"]