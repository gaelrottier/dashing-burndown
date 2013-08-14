## Description

This [Dashing](http://shopify.github.io/dashing/) widget allows you to see the current burndown of your iteration, thanks to [Pivotal Tracker](http://pivotaltracker.com/)'s API

  * On the top of the widget, there is the current number of iteration.
  * At top left, there is the total number of points of the iteration.
  * On the top of the point of the graph representing the current day, there is the number of points left in the iteration.

## Usage

If you want to add the widget directly in your project, see the [gist about it](https://gist.github.com/gaelrottier/6194375)  
  
  
1. Clone the project `git clone https://github.com/gaelrottier/dashing-burndown.git`.
2. Run `bundle install`.
3. Get a Pivotal Tracker API token from your [Account Dashboard](https://www.pivotaltracker.com/profile), or execute `curl -u $USERNAME:$PASSWORD -X GET https://www.pivotaltracker.com/services/v3/tokens/active` in the command line, then set `TOKEN` in jobs/burndown.rb to it.
4. Get the id of the project you want to track, that can be found in the url of the project, `https://www.pivotaltracker.com/s/projects/$PROJECT_ID`, or by running `curl -H "X-TrackerToken: $TOKEN" -X GET http://www.pivotaltracker.com/services/v3/projects` in command line, and set `PROJECT` in jobs/burndown.rb to it.
5. If you haven't been using Pivotal Tracker since the start of your project, set `ITERATION_NUMBER_OFFSET` in `jobs/burndown.rb` to the number of iterations you want to add to the total of iterations of the project.


## Preview

![burndown.jpg](http://i.imgur.com/Fp9eI4Q.png "Burndown image") ![burndown.jpg](http://i.imgur.com/3TjrXCR.png?1 "Burndown image")

## Contributing

1. Fork it.
2. Create your feature branch (git checkout -b my-new-feature).
3. Commit your changes (git commit -am 'Add some feature').
4. Push to the branch (git push origin my-new-feature).
5. Create new Pull Request.

## Credits

This project was done during my internship at [M.E.S.H.](https://github.com/MESHMD), of which I thank very much the employees for their greeting during all the time I was with them.

## License

See the [License page](LICENSE.md).
