# Annotation Studio
An annotation platform designed for teaching and learning in the humanities, and with aspirations to more general use.

## Dependency: MIT Annotation Data Store
https://github.com/hyperstudio/MIT-Annotation-Data-Store

Set the data store up first, then rename application.sample.yml to application.yml
and point your annotation studio instance to the API in that config file.

## Installation
Set up Rails and Postgres (if you haven't yet, try: https://github.com/thoughtbot/laptop)

Then:
- ```mkdir annotation-studio```
- ```cd annotation-studio```
- ```git clone git@github.com:hyperstudio/Annotation-Studio.git```
- ```bundle install```
- Create a PostgreSQL database, add the connection information into database.sample.yml and copy that file to database.yml.
- Update application.yml and database.yml with your configuration preference.
- ```Rake db migrate```
- ```rails s```

## Thanks
Thanks to @OKFN and @nickstenning for creating The Annotator: https://github.com/okfn/annotator/ which is bundled here.

## Author
- Lab: MIT HyperStudio
- http://hyperstudio.mit.edu/
- Developer: Jamie Folsom
- jfolsom@mit.edu

## License
GPL2

http://www.gnu.org/licenses/gpl-2.0.html
