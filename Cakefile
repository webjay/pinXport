{exec} = require 'child_process'

task 'build', 'Build from src/*.coffee to bin/*.js', ->
	exec 'coffee --compile --output bin src', (err, stdout, stderr) ->
		throw err if err?
		console.log stdout + stderr