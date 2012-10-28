#!/usr/bin/env coffee


request = require 'request'
optimist = require('optimist')
	.usage('Usage: $0 --token [Pinboard token] --tag [tag] --output [csv] --site [site uri]')
	.alias('t', 'tag')
	.default('output', 'csv')
	.default('site', 'api.pinboard.in')
xml2js = require 'xml2js'


quote_re = new RegExp('"', 'g')
argv = optimist.argv
	
csvLineItem = (item) ->
	return '"' + item.replace(quote_re, '""') + '"'
	
jsonToCsv = (posts) ->
	csv = []
	csv.push '"tags", "title", "uri"'
	for post in posts
		tags = post.tags || post.tag
		line = ''
		line += csvLineItem(tags) + ','
		line += csvLineItem(post.description) + ','
		line += csvLineItem(post.href)
		csv.push line
	return csv.join('\n')


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
	json: true
	headers:
		Connection: 'close'
		'User-Agent': 'pinXport (https://github.com/webjay/pinXport)'

request.get options, (err, request, posts) ->
	return console.error err if err?
	if request.statusCode isnt 200
		console.error 'Status: ' + request.statusCode
		console.error optimist.help()
		return
	if typeof posts isnt 'object'
		parser = new xml2js.Parser mergeAttrs: true
		parser.parseString posts, (err, json) ->
			return console.error 'Error parsing XML: ' + err if err?
			console.log jsonToCsv json.posts.post
	else
		console.log jsonToCsv posts
