# pinXport

[![Build Status](https://secure.travis-ci.org/webjay/pinXport.png)](http://travis-ci.org/webjay/pinXport)

pinXport enables you to export links from either [Pinboard](http://pinboard.in/) or [Delicious](http://delicious.com/).
Built in [CoffeeScript](http://coffeescript.org/).

### Install

	npm install pinxport

### Usage

To get results from Pinboard with a specific tag do this:

	pinxport --token=[Pinboard token] --tag [tag] > results.csv

To get results with multiple tags do this:

	pinxport --token=[Pinboard token] --tag [tag1] --tag [tag2] > results.csv

To get results with a specific tag from Delicious do this:

	pinxport --site [username]:[password]@api.del.icio.us --tag [tag] > results.csv
