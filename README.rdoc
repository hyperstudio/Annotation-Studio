## Annotation Studio
Hyperstudio Annotation Application.

##  
### Compatible with the MIT Annotation Data Store
https://github.com/hyperstudio/MIT-Annotation-Data-Store

Set the data store up first, then point your annotation studio instance to the API
in the application config file: application.sample.yml

## Dependencies
### OKFN Annotator
https://github.com/okfn/annotator/

## Installation
Set up rails and postgres (if you haven't yet, try: https://github.com/thoughtbot/laptop)

Then:

```mkdir annotation-studio```
```cd annotation-studio```
```git clone git@github.com:hyperstudio/Annotation-Studio.git```
```bundle install```
```Rake db migrate```
```rails s```

## Author
- Lab: MIT HyperStudio
- http://hyperstudio.mit.edu/
- Developer: Jamie Folsom
- jfolsom@mit.edu

## License
GPL2
&copy; MIT 2013
