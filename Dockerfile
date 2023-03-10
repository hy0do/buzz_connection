FROM asia.gcr.io/buzz-connection/rails-base:stable

WORKDIR /app
COPY . /app

ARG _RAILS_MASTER_KEY
ENV RAILS_MASTER_KEY ${_RAILS_MASTER_KEY}
ENV RAILS_SERVE_STATIC_FILES 1

RUN bundle install

ENV NODE_ENV production
RUN yarn install --check-files

ENV RAILS_ENV production
RUN bin/rails assets:precompile 

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

EXPOSE 3000

CMD ["bin/rails", "server", "-b", "0.0.0.0", "-e", "production"]
