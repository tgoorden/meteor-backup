meteor-backup
=============

Two simple scripts to make backups of collections on your remote meteor installation and to convert the result into csv. Since the Meteor provided hosting rotates the password to your MongoDB every few minutes, this beats having to do really annoying copy-paste operations.

To install using npm:
```
sudo npm install -g meteor-db-utils
```
(This is a global installation, which you probably want for a command line tool like this.)

To export/backup JSON files for collections on your production site:

```
meteor-backup [domain] [collection...]
```
e.g.
```
meteor-backup examples.meteor.com users
```
You can list multiple collections, they will be exported to separate files.

Options:
```
-d [dir]
```
Specify the directory to save to.

```
--prefix [prefix]
--postfix [postfix]
```
Append or prepend a string to your JSON filenames (the name of the collection is the base name). You can use this to datestamp your export for instance.


Keep in mind:
* mongoexport has to be available on your command line, this is not installed automatically
* This has been tested with a Meteor 0.8.0 installation, it probably does not work with earlier (0.6.5) ones.

meteor-json2csv
===============

It also includes a pretty cool script to convert the result to a CSV file.

Usage of the conversion script:
```
meteor-json2csv <inputfile> [outputfile]
```

Outputfile is optional, the script will write to the console if no outputfile is specified.

This script will "flatten" any subdocuments and arrays. So, objects like:
```
{"name":"Example","subdoc":{"amount":1,"description":"Foo"},"array":["first","second"]}
```
will be converted into:
```
"name","subdoc_amount","subdoc_description","array_0","array_1"
"Example","1","Foo","first","second"
```
before being converted into a CSV line. Yes, this works recursively and yes, content with the same key is gathered in the same column.

You can probably use this script for other JSON to CSV conversions as well, as long as they use the same structure as mongoexport created files. For instance, every document is listed on a different line, not as an element in a large array.

The scripts are written in Coffeescript, any improvements are welcome!
