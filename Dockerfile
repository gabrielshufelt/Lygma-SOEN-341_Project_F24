# syntax = docker/dockerfile:1

# ARG to set the Ruby version, matching the Gemfile and .ruby-version
ARG RUBY_VERSION=3.3.5
ARG RAILS_ENV=production  # Set default RAILS_ENV as production
FROM registry.docker.com/library/ruby:$RUBY_VERSION-slim as base

# Install necessary packages
RUN apt-get update -qq && \
    apt-get install -y build-essential libvips bash bash-completion libffi-dev tzdata postgresql-client libpq-dev nodejs npm yarn && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /usr/share/doc /usr/share/man

# Set working directory for Rails app
WORKDIR /rails

# Ensure we pass RAILS_ENV at runtime
ENV RAILS_ENV=${RAILS_ENV}

# Set BUNDLE_PATH dynamically based on environment
ENV BUNDLE_PATH="/usr/local/bundle"

# Stage for building gems and assets
FROM base as build

# Install additional packages for building gems
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y git pkg-config

# Copy Gemfile and Gemfile.lock
COPY Gemfile Gemfile.lock ./

# Install gems
RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git

# Copy application code
COPY . .

# Precompile bootsnap and assets for faster boot times and production optimization
RUN bundle exec bootsnap precompile app/ lib/ && \
    SECRET_KEY_BASE_DUMMY=1 bundle exec rails assets:precompile

# Final stage (for production and development)
FROM base

# Copy built gems and app files
COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /rails /rails

# Make sure entrypoint script is executable
RUN chmod +x /rails/bin/docker-entrypoint

# Non-root user for security
RUN useradd -ms /bin/bash rails && \
    chown -R rails:rails /rails
USER rails:rails

# Expose port 3000
EXPOSE 3000

# Use the entrypoint script to prepare the database
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

# Default command (can be overridden in docker-compose.yml)
CMD ["./bin/rails", "server"]


