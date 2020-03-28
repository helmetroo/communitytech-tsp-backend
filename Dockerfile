# Ruby + Rails necessities
FROM ruby:2.7
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client
RUN mkdir /communitytech-tsp
WORKDIR /communitytech-tsp
COPY Gemfile /communitytech-tsp/Gemfile
COPY Gemfile.lock /communitytech-tsp/Gemfile.lock

# Installs or-tools C++ library
RUN apt-get -y install zlib1g-dev curl
RUN mkdir /communitytech-tsp-lib
WORKDIR /communitytech-tsp-lib
RUN curl -L https://github.com/google/or-tools/releases/download/v7.5/or-tools_ubuntu-18.04_v7.5.7466.tar.gz > or-tools.tar.gz
RUN mkdir ./or-tools
RUN tar -xzf or-tools.tar.gz --strip 1 -C ./or-tools
RUN cp -a ./or-tools/lib/. /usr/lib/
RUN ldconfig -n -v /usr/lib
RUN bundle config build.or-tools --with-or-tools-dir=/communitytech-tsp-lib/or-tools
WORKDIR /communitytech-tsp

# Install all gems
RUN bundle install
COPY . /communitytech-tsp

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000
EXPOSE 5432

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]
