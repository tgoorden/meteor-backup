meteor-backup
=============

A simple (coffee)script to make backups of collections on your remote meteor installation. Since the Meteor provided hosting rotates the password to your MongoDB every few minutes, this beats having to do really annoying copy-paste operations.


The backup script requires the 'nomnom' and 'underscore' npm libraries to be installed, as well as command-line coffeescript.

Usage is simple:
```
backup.coffee [domain] [collection]...
```

This will create a json file with the name of your collection, using the mongoexport command. The results are saved in [collection].json files.

It also includes a pretty cool script to convert the result to a CSV file. This script will "flatten" any subdocuments. So, objects like:
``` {"name":"Example","subdoc":{"amount":1,"description":"Foo"}}
will be converted into
``` {"name":"Example","subdoc_amount":1,"subdoc_description":"Foo"}}
before being converted into a CSV line.

Usage of the conversion script:
```json2csv.coffee [input file.json]

You can write the result into a csv file as such:
```json2csv.coffee [input file.json] > [output file.csv]

Caveat: I'm not sure what happens when you have subdocuments consisting of arrays. In any case, there is no obvious way to shoehorn this type of structure into a sensible csv file anyway.
