# web: bundle exec rails server thin -p $PORT -e $RACK_ENV
web: bundle exec unicorn -p $PORT -c ./config/unicorn.rb
worker:  bundle exec rake jobs:work
