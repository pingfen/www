FROM alpine:3.9
MAINTAINER Xue Bing <xuebing1110@gmail.com>

# repo
RUN cp /etc/apk/repositories /etc/apk/repositories.bak
RUN echo "http://mirrors.aliyun.com/alpine/v3.9/main/" > /etc/apk/repositories
RUN echo "http://mirrors.aliyun.com/alpine/v3.9/community/" >> /etc/apk/repositories

# timezone
RUN apk update
RUN apk add --no-cache tzdata \
    && echo "Asia/Shanghai" > /etc/timezone \
    && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

# git
RUN apk add git curl wget

# hugo
#RUN curl https://github.com/gohugoio/hugo/releases/download/v0.54.0/hugo_0.54.0_Linux-64bit.tar.gz -o hugo_0.54.0_Linux-64bit.tar.gz
RUN wget https://github.com/gohugoio/hugo/releases/download/v0.54.0/hugo_0.54.0_Linux-64bit.tar.gz -O hugo_0.54.0_Linux-64bit.tar.gz
RUN tar xzvf ./hugo_0.54.0_Linux-64bit.tar.gz
RUN cp ./hugo /usr/local/bin/
RUN hugo version
RUN hugo new site www
RUN cd www
RUN git clone https://github.com/jugglerx/hugo-hero-theme.git themes/hugo-hero-theme
COPY ./config.toml ./config.toml

EXPOSE 80
CMD hugo server --bind 0.0.0.0 -p 80 --baseURL http://www.pingfen.io
