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

# git
RUN apk add git curl wget

# hugo
RUN mkdir /app
WORKDIR /app
RUN hugo version
RUN hugo new site www
WORKDIR /app/www
RUN wget https://codeload.github.com/JugglerX/hugo-hero-theme/zip/master -O themes/hugo-hero-theme.zip
RUN unzip themes/hugo-hero-theme.zip -d ./themes
RUN mv ./themes/hugo-hero-theme-master ./themes/hugo-hero-theme
RUN cp -a themes/hugo-hero-theme/exampleSite/. .
COPY static/images/* ./themes/hugo-hero-theme/static/images/
COPY static/favicon.png ./static/favicon.png

# my configuration
RUN rm -f ./content/services/*
COPY ./content ./content
COPY ./data ./data
COPY ./config.toml ./config.toml

# custome layouts
RUN sed -i 's/images\/logo.svg/images\/logo.png/g' ./themes/hugo-hero-theme/layouts/partials/header.html
RUN sed -i 's/images\/logo-mobile.svg/images\/logo-mobile.png/g' ./themes/hugo-hero-theme/layouts/partials/header.html
RUN sed -i 's/Our Services/{{ .Site.Params.service_name }}/g' ./themes/hugo-hero-theme/layouts/index.html
RUN sed -i 's/View All Services/{{ .Site.Params.view_all_service }}/g' ./themes/hugo-hero-theme/layouts/index.html
RUN sed -i 's/Hugo Hero Theme Demo/{{ .Site.Title }}/g' ./themes/hugo-hero-theme/layouts/index.html
RUN sed -i 's/{{ .Permalink }}/#/g' ./themes/hugo-hero-theme/layouts/services/summary.html
RUN sed -i 's/www.zerostatic.io/{{ .Site.BaseURL }}/g' ./themes/hugo-hero-theme/layouts/partials/sub-footer.html

# replace google resource
RUN sed -i 's/https:\/\/fonts.googleapis.com/http:\/\/fonts.proxy.ustclug.org/g' ./themes/hugo-hero-theme/assets/scss/style.scss

EXPOSE 443
CMD hugo server --bind 0.0.0.0 -p 443 --baseURL https://pingfen.io
