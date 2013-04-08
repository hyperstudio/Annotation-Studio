## Annotation Studio
Hyperstudio Annotation Application.

##  
### Compatible with the MIT Annotation Data Store
https://github.com/hyperstudio/MIT-Annotation-Data-Store

Set the data store up first, then rename application.sample.yml to application.yml
and point your annotation studio instance to the API in that config file.

## Installation
Set up rails and postgres (if you haven't yet, try: https://github.com/thoughtbot/laptop)

Then:
- ```mkdir annotation-studio```
- ```cd annotation-studio```
- ```git clone git@github.com:hyperstudio/Annotation-Studio.git```
- ```bundle install```
- ```Rake db migrate```
- ```rails s```

## Thanks
### @OKFN and @nickstenning
For the Annotator: https://github.com/okfn/annotator/ which is bundled here.

## Author
- Lab: MIT HyperStudio
- http://hyperstudio.mit.edu/
- Developer: Jamie Folsom
- jfolsom@mit.edu

## License
GPL2
http://www.gnu.org/licenses/gpl-2.0.html
