# README

Foundation based off setting up from [here](https://docs.docker.com/compose/rails/).

Using commands to generate things with Rails on Linux under Docker assigns them root permissions. Fix this by running (from the root):
```bash
sudo chown -R $USER:$USER .
```


This README would normally document whatever steps are necessary to get the

application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
