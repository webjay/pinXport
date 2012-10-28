#!/usr/bin/env coffee

request = require 'request'
argv = require('optimist')
	.usage('Usage: $0 --token [Pinboard token] --tag [tag] --output [csv] --site [site uri]')
	.alias('t', 'tag')
	.default('output', 'csv')
	.default('site', 'api.pinboard.in')
	.argv

quote_re = new RegExp('"', 'g')
	
csvLineItem = (item) ->
	return '"' + item.replace(quote_re, '""') + '"'

if argv.tag?
	tagstr = if typeof argv.tag is 'string' then argv.tag else argv.tag.join(',')
else
	tagstr = ''

options =
	uri: 'https://' + argv.site + '/v1/posts/all'
	qs:
		auth_token: argv.token
		tag: tagstr
		format: 'json'
		meta: 'no'
	json: true
	headers:
		Connection: 'close'
		'User-Agent': 'pinXport (https://github.com/webjay/pinXport)'
	
request.get options, (err, request, posts) ->
	return console.error err if err?
	return console.log 'No results. Server says: ' + posts if typeof posts isnt 'object'
	csv = []
	csv.push '"tags", "title", "uri"'
	for post in posts
		line = ''
		line += csvLineItem(post.tags) + ','
		line += csvLineItem(post.description) + ','
		line += csvLineItem(post.href)
		csv.push line
	console.log csv.join('\n')
