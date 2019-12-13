FROM alpine:3.10 as build

SHELL ["/bin/ash", "-eo", "pipefail", "-c"]
ENV BUNDLE_SILENCE_ROOT_WARNING=1

WORKDIR /app

RUN apk add --no-cache \
   build-base \
   git \
   ruby \
   ruby-bundler \
   ruby-dev \
   ruby-ffi

COPY Gemfile Gemfile.lock ./

RUN bundle install --frozen -j4 -r3 --no-cache --without development test \
 && bundle clean --force \
 && rm -rf /usr/lib/ruby/gems/*/cache \
 && scanelf --needed --nobanner --recursive /usr/lib/ruby/gems \
      | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
      | sort -u \
      | xargs -r ash -c 'apk info --installed "$@" || true' \
      | sort -u > .rundeps

COPY . .
RUN rm -rf \
      .git \
      /usr/lib/ruby/gems/*/cache \
      Dockerfile \
      coverage \
      log \
      spec \
      tmp

FROM alpine:3.10

ENV WEB_CONCURRENCY=4 \
    WEB_MAX_THREADS=4 \
    RACK_ENV=production

COPY --from=build /app/.rundeps ./
RUN apk add --no-cache \
      $(cat .rundeps) \
      libcurl \
      ruby
COPY --from=build /usr/lib/ruby/gems/ /usr/lib/ruby/gems/
COPY --from=build /app/ .
EXPOSE 9292
USER nobody
STOPSIGNAL SIGINT
CMD ["bin/puma"]
