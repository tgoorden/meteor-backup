#!/usr/bin/env coffee

exec = require('child_process').exec
sys = require 'sys'
_ = require 'underscore'

cdl = require('nomnom').script("backup").options
	domain:
		position: 0
		help: "The Meteor domain to backup"
		required: true
	collections:
		position: 1
		help: "Which collections to include"
		list: true
		required: true
	dir:
		abbr: 'd'
		full: 'dir'
		metavar: 'PATH'
		help: "The directory where JSON files will be saved (please end with '/', defaults to current dir)"
		default: './'
	prefix:
		full: "prefix"
		help: "Prefix text to prepend to JSON filename (e.g. a date)"
		default: ""
	postfix:
		full: "postfix"
		help: "Postfix text to append to JSON filename (e.g. a date)"
		default: ""

options = cdl.parse()

exec "meteor mongo #{options.domain} --url", (error,stdout,stderr)->
	if stderr
		console.log "Error getting domain URL:"
		console.log stderr
	if stdout
		# console.log "URL: #{stdout}"
		# If you want to know what the next line is about,
		# check the output of "meteor mongo <domain> --url"
		url = stdout.split /:\/\/|:|@|\/|\n|\r/
		protocol = url[0]
		username = url[1]
		password = url[2]
		host = url[3]
		port = url[4]
		db = url[5]
		# pad the directory with a '/' if necessary:
		dir = options.dir
		if dir.charAt(dir.length-1) isnt '/'
			dir = dir + '/'
		_.each options.collections, (collection)->
			exportCmd = "mongoexport -h #{host} --port #{port} -u #{username} -p #{password} -d #{db} -c #{collection} -o #{dir}#{options.prefix}#{collection}#{options.postfix}.json"
			console.log exportCmd
			exec exportCmd, (err,sout,serr)->
				if sout
					console.log sout
				if serr
					console.log "An error occurred during export:"
					console.log serr
