#!/usr/bin/env coffee

request = require 'request'
argv = require('optimist')
	.usage('Usage: $0 --token [Pinboard token] --tag [tag] --output [csv]')
	.demand(['token', 't'])
	.alias('t', 'tag')
	.alias('o', 'output')
	.default('o', 'csv')
	.argv
	
quote_re = new RegExp('"', 'g')
	
csvLineItem = (item) ->
	return '"' + item.replace(quote_re, '""') + '"'

tagstr = if typeof argv.t is 'string' then argv.t else argv.t.join(',')

options =
	uri: 'https://api.pinboard.in/v1/posts/all'
	qs:
		auth_token: argv.token
		tag: tagstr
		format: 'json'
	json: true
	
request.get options, (err, request, posts) ->
	return console.error err if err?
	csv = []
	csv.push '"tags", "title", "uri"'
	for post in posts
		line = ''
		line += csvLineItem(post.tags) + ','
		line += csvLineItem(post.description) + ','
		line += csvLineItem(post.href)
		csv.push line
	console.log csv.join('\n')
