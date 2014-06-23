# Annotation Studio
An annotation platform designed for teaching and learning in the humanities,
and with aspirations to more general use.

## Works with: MIT Annotation Data Store
There are two servers required to run this application. This one, and the [MIT
Annotation Data Store](https://github.com/hyperstudio/MIT-Annotation-Data-Store
).

You __MUST__ get the Annotation server running to be able to create or view
annotations.

# Getting Started

## Things to install
Annotation Studio uses PostgreSQL

The MIT Annotation Data Store requires Node.js (0.10.21), NPM (1.3.11) and
MongoDB

## General Installation
Set up Rails (if you haven't yet, try: [thoughtbot's Laptop repo]
(https://github.com/thoughtbot/laptop))

- ```git clone git@github.com:hyperstudio/Annotation-Studio.git
annotation-studio```
- ```cd annotation-studio```
- ```./bin/setup```

which will:

* Drop existing databases
* Run migrations and prepare the test database
* Seed the application
* Install the MIT Annotation Data Store under `./tmp/annotation_data_store`
* Create an example application.yml

After setting up the app, run:

```bash
bundle exec foreman start -f Procfile.dev
```

to spin up development dependencies. You can exist the development daemons by
hitting ctrl-c, per normal unix semantics.

### Installation on Heroku
If you would like to run the application on Heroku (recommended), do the
following

- Create a Heroku app `heroku apps:create $APPNAME`
- Add the Heroku PostgreSQL add-on `heroku addons:add heroku-postgresql`
  - Don't worry about providing db configuration, [Heroku will do it for you]
(https://devcenter.heroku.com/articles/heroku-postgresql#connecting-in-rails)
- Use Figaro to load your `application.yml` into environment variables and
communicate them to Heroku
  -  `rake figaro:heroku[$APPNAME]`

## User Support and Developer forum
http://support.annotationstudio.org

## Thanks
Thanks to:
- [NEH Office of Digital Humanities](http://www.neh.gov/odh) who has funded
this project
- [OKFN](http://okfn.org/) for supporting [The Annotator]
(http://annotatorjs.org)
- [Nick Stenning](https://github.com/nickstenning/) for being awesome and for
leading the Annotator developer team
- [Dan Whaley, Randall Leeds and hypothes.is](https://hypothes.is/) for being
awesome and supporting the Annotator Community
- [The Annotator community](https://github.com/openannotation/annotator/) for
plugins and being awesome.

## Contributors
### Lab
- MIT HyperStudio
- http://hyperstudio.mit.edu/

### Developers
- Jamie Folsom [@jamiefolsom](http://github.com/jamiefolsom)
- Liam Andrew [@mailbackwards](http://github.com/mailbackwards)
- Andrew Magliozzi [@andrewmagliozzi](http://github.com/andrewmagliozzi)
- Daniel Collis-Puro [@djcp](http://github.com/djcp)
- Seth Woodworth [@sethwoodworth](http://github.com/sethwoodworth)
- Ayse Gursoy [@gursoy](http://github.com/gursoy)
- Jacob Hilker [@jhilker](http://github.com/jhilker)

## License
GPL2: http://www.gnu.org/licenses/gpl-2.0.html
