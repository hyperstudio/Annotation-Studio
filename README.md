# Annotation Studio
An annotation platform designed for teaching and learning in the humanities, and with aspirations to more general use.

## Works with: MIT Annotation Data Store
There are two servers required to run this application. This one, and the [MIT Annotation Data Store](https://github.com/hyperstudio/MIT-Annotation-Data-Store).
You __MUST__ get the Annotation server running to be able to create or view annotations.



## General Installation
Set up Rails (if you haven't yet, try: [Thoughtbot's Laptop repo](https://github.com/thoughtbot/laptop))

Do these first, regardless if you are installing locally or on Heroku:
- ```git clone git@github.com:hyperstudio/Annotation-Studio.git annotation-studio```
- ```cd annotation-studio```
- ```bundle install```
- Copy `config/application.sample.yml` to `config/application.yml` _Do not check this into git_
- Update `config/application.yml` with your configuration preferences: See file for in-line comments
- Update the `API_CONSUMER` value in application.yml to point to the full URI of your running instance of MIT-Annotation-Data-Store


### Localhost installation
These are rough instructions on how to get Annotation Studio working on your local development machine or server

- Install and setup PostgreSQL-server (see Laptop repo above)
- Create a PostgreSQL database
- Copy `config/database.sample.yml` to `config/database.yml`
- Add PostgreSQL connection URI into database.yml
- `Rake db migrate`
- `rake db:seed`
- ```rails s```

### Installation on Heroku
If you would like to run the application on Heroku (recommended), do the following


- Create a Heroku app `heroku apps:create $APPNAME`
- Add the Heroku PostgreSQL add-on `heroku addons:add heroku-postgresql`
  - Don't worry about providing db configuration, [Heroku will do it for you](https://devcenter.heroku.com/articles/heroku-postgresql#connecting-in-rails)
- Use Figaro to load your `application.yml` into environment variables and communicate them to Heroku
  -  `rake figaro:heroku[$APPNAME]`


## Thanks
Thanks to [OKFN](https://github.com/okfn/) and [Nick Stenning](https://github.com/nickstenning/) for creating The Annotator: https://github.com/okfn/annotator/ which is bundled here.

## Author
- Lab: MIT HyperStudio
- http://hyperstudio.mit.edu/
- Developer: Jamie Folsom
- jfolsom@mit.edu

## License
GPL2

http://www.gnu.org/licenses/gpl-2.0.html
