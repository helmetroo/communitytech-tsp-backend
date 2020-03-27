# Ruby + Rails necessities
FROM ruby:2.7
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client
RUN mkdir /communitytech-tsp
WORKDIR /communitytech-tsp
COPY Gemfile /communitytech-tsp/Gemfile
COPY Gemfile.lock /communitytech-tsp/Gemfile.lock
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
