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

options = cdl.parse()

exec "meteor mongo #{options.domain} --url", (error,stdout,stderr)->
	if stderr
		console.log "Error getting domain URL:"
		console.log stderr
	if stdout
		console.log "URL: #{stdout}"
		url = stdout.split /:\/\/|:|@|\/|\n|\r/
		protocol = url[0]
		username = url[1]
		password = url[2]
		host = url[3]
		port = url[4]
		db = url[5]
		_.each options.collections, (collection)->
			exportCmd = "mongoexport -h #{host} --port #{port} -u #{username} -p #{password} -d #{db} -c #{collection} -o #{collection}.json"
			console.log exportCmd
			exec exportCmd, (err,sout,serr)->
				if sout
					console.log sout
				if serr
					console.log serr
