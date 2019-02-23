FROM jojomi/hugo:latest
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

# work dir
RUN mkdir -p /app
RUN cd /app

# hugo
RUN hugo new site www
RUN cd www
git clone https://github.com/jugglerx/hugo-hero-theme.git themes/hugo-hero-theme
COPY ./config.toml ./config.toml


EXPOSE 80
CMD hugo server --bind 0.0.0.0 -p 80 --baseURL http://www.pingfen.io