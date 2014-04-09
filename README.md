meteor-backup
=============

A simple (coffee)script to make backups of collections on your remote meteor installation. Since the Meteor provided hosting rotates the password to your MongoDB every few minutes, this beats having to do really annoying copy-paste operations.

It requires the 'nomnom' and 'underscore' npm libraries to be installed, as well as command-line coffeescript.

Usage is simple:
```
backup.coffee [domain] [collection]...
```

This will create a json file for every collection(s) listed, using the mongoexport command.
