#!/usr/bin/env coffee

fs = require 'fs'
_ = require 'underscore'

cdl = require('nomnom').script("json2csv").options
	inputFile:
		position: 0
		help: "The JSON file to convert"
		required: true
	outputFile:
		position: 1
		help: "The name of the CSV output file (optional)"
		required: false

options = cdl.parse()

# Flattens an object, by concatenating key names using an "_".
# In effect, this will convert something like:
# {"name":"Example","subdoc":{"amount":1,"description":"Foo"}}
# into
# {"name":"Example","subdoc_amount":1,"subdoc_description":"Foo"}}

flatten = (root = "",obj)->
	result = {}
	_.each _.keys(obj), (key)->
		value = obj[key]
		# Since arrays are objects too, we deal with them first:
		if _.isArray value
			_.each value, (element,index)->
				indexed_key = key + "_" + index
				if _.isObject element
					_.extend result, flatten(indexed_key, element)
				else
					result[indexed_key] = element
		else
			if _.isObject value
				# Recursively deconstruct the underlying object:
				_.extend result, flatten(key, value)
			else
				if root isnt ""
					key = root + "_" + key
				result[key] = value
	return result

fs.readFile options.inputFile, {encoding:"UTF-8"}, (err,data)->
		if err
			console.log err
		if data
			parsed = []
			lines = data.split /[\n\r]/
			_.each lines, (line)->
				input = line.trim()
				if input isnt ""
					parsed.push JSON.parse input
			# console.log "Found #{parsed.length} lines"
			# First, we flatten the structure
			flat = []
			_.each parsed, (obj)->
				flat.push flatten "",obj
			# Extract all the unique (concatenated) keys:
			unique_keys = []
			_.each flat, (obj)->
				_.each _.keys(obj), (key)->
					unless _.contains unique_keys, key
						unique_keys.push key
			# Create a write function to either the console
			# or the outputFile (if provided)
			write = console.log
			if options.outputFile
				write = (text)->
					fs.appendFile options.outputFile, text + '\n', (err)-> throw err
			# Print the whole shebang to the stdout in csv format
			# First, the headers:
			write _.map(unique_keys,(k)->"\"#{k}\"").join ","
			# And.. the contents
			_.each flat, (obj)->
				try
					csv = []
					_.each unique_keys, (key)->
						csv.push obj[key] || ""
					# Put quotes around everything and escape quotes in strings:
					# Yes, quotes are escaped by a quote character!
					padded = _.map csv,(v)->
						if _.isString v
							v = v.replace /\"/g, "\"\""
						return "\"#{v}\""
					write padded.join ","
				catch error
					console.log "Error processing: ",obj
					throw error
