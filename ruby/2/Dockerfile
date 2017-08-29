FROM ruby:2.4-slim

# Define where our application will live inside the image, and home for bundler
ENV RAILS_ROOT=/var/www/app HOME=$RAILS_ROOT TZ=Asia/Tehran

RUN \
  # Install essential Linux packages
  apt-get update -qq && apt-get install -y build-essential libpq-dev postgresql-client ruby-dev & \
  # Install SQLITE for test
  apt-get install libsqlite3-dev & \
  # For a JS runtime
  apt-get install -y nodejs & \
  # Set timezone
  ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && \
  # Create application home and the pids dir at the same time (-p)
  mkdir -p $RAILS_ROOT/tmp/pids

# Set our working directory inside the image
WORKDIR $RAILS_ROOT
EXPOSE 8080
CMD ["start.sh"]

COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
# Prevent bundler warnings; ensure that the bundler version executed is >= that which created Gemfile.lock
RUN gem install bundler

# Finish establishing our Ruby env
RUN bundle install

# Copy the Rails application into place and fix permissions
COPY . /tmp/app
RUN chmod -R ug+rwx /tmp/app $RAILS_ROOT/tmp $RAILS_ROOT/log && \
    chown -R 1001:0 /tmp/app $RAILS_ROOT/tmp $RAILS_ROOT/log && \
    cp -rpT /tmp/app . && \
    rm -rf /tmp/app

# Precompile assets
RUN rake assets:precompile

USER 1001
