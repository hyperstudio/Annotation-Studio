threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }.to_i
threads threads_count, threads_count

preload_app!

rackup DefaultRackup
port ENV.fetch("PORT") { 3000 }
environment ENV.fetch("RAILS_ENV") { "development" }
# On development, run ssl server on port 3001
if ENV.fetch("RAILS_ENV") == "development"
  ssl_bind "localhost", "3001", {
    key: ENV.fetch("SSL_KEY_PATH"),
    cert: ENV.fetch("SSL_CERT_PATH"),
    verify_mode: "none",
  }
end

# Windows only:
# workers ENV.fetch("WEB_CONCURRENCY") { 2 }

on_worker_boot do
  # Worker specific setup for Rails 4.1+
  # See: https://devcenter.heroku.com/articles/deploying-rails-applications-with-the-puma-web-server#on-worker-boot
  ActiveRecord::Base.establish_connection
end

# Allow puma to be restarted by `rails restart` command.
plugin :tmp_restart