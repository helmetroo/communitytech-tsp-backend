# communitytech-tsp

This is a Rails app exposing an API endpoint fetching the shortest route through an ordered list of addresses.

Foundation was set up using [this](https://docs.docker.com/compose/rails/) as a guide.

# API

**Get shortest route**
----
Returns a JSON object with `geolocations` array, which is the geolocations of the addresses in the order you provided them to the API, and an `order` array giving the order in which these addresses should be visited (as array indices), which is the shortest route through them.

* **URL**

  /shortest-route

* **Method:**

  `GET`
  
*  **URL Params**

   **Required:**
 
   `addresses=[string_array]`

   Each item in the array is separated by a `|` (pipe), like `Seattle,WA|Portland,OR|Los%20Angeles,CA|Denver,CO|Des%20Moines,IA`.

* **Success Response:**

  * **Code:** 200 <br />
    **Content:** `{"geolocations":[{"latitude":47.6038321,"longitude":-122.3300624},{"latitude":45.5202471,"longitude":-122.6741949},{"latitude":34.0536909,"longitude":-118.2427666},{"latitude":39.7392364,"longitude":-104.9848623},{"latitude":41.5910641,"longitude":-93.6037149}],"order":[0,4,3,2,1]}`
 
* **Error Response:**

  TODO
  

# Development

You'll need docker and docker-compose installed. Get the app built up and running on your machine with
```bash
docker-compose up
```

You should always run `rails` commands, `gem install`s on top of Docker.
```bash
docker-compose run web rails
```

If you install some packages with bundler, you'll want to rebuild with
```bash
docker-compose run web bundle install && docker-compose up --build
```

## If you're running Linux
Using rails commands to generate stuff on Linux using Docker assigns the new files root permissions. Fix this by running this snippet from the root of the app before you start working on those files:
```bash
sudo chown -R $USER:$USER .
```

# Deploying
We use Heroku to host the production release. It's at [communitytech-tsp.herokuapp.com](https://communitytech-tsp.herokuapp.com).

Docker images for the app are deployed to run on Heroku, not by using a traditional `git push`. 

## Steps
Make sure you're logged in to Heroku's container registry.
If you logged in already, you can skip this step.
```bash
heroku container:login
```

Build the image for the app, and push it to the container registry.
```bash
heroku container:push web
```

Release the image for the app.
```bash
heroku container:release web
```

Visit the app on Heroku to make sure everything is working.
```bash
heroku open
```

One-liner for building and releasing.
```bash
heroku container:push web && heroku container:release web
```

# Relevant links

- [https://developers.google.com/optimization/routing/tsp](https://developers.google.com/optimization/routing/tsp)
- [https://developers.google.com/optimization/routing/vrp](https://developers.google.com/optimization/routing/vrp)
- [https://developers.google.com/optimization/routing/pickup_delivery](https://developers.google.com/optimization/routing/pickup_delivery)
- [https://github.com/ankane/or-tools](https://github.com/ankane/or-tools)
- [https://github.com/Skalar/google_distance_matrix](https://github.com/Skalar/google_distance_matrix)
- [https://docs.docker.com/compose/rails/](https://docs.docker.com/compose/rails/)
