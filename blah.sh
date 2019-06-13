echo 'creating local application.yml'

  cat > config/application.yml <<EOF

development:
  RACK_ENV:                               development
  RAILS_ENV:                              development
  API_CONSUMER:                           name-of-the-app-on-which-the-annotator-runs
  API_SECRET:                             the-secret-the-annotator-gets-from-the-authorizing-site
  API_URL:                                http://localhost:3000/api
  AWS_ACCESS_KEY_ID:                      aws_access_key
  AWS_SECRET_ACCESS_KEY:                  aws_secret_access_key
  ANNOTATOR_FILTER:                       false
  ANNOTATOR_RICHTEXT:                     false
  ANNOTATOR_RICHTEXT_CONFIG:              "undo redo | styleselect | bold italic | link image media | code"
  CONFIRMATION_GRACE_PERIOD:              2
  DEFAULT_USERS_CAN_CHOOSE_GROUPS:        true
  DEFAULT_USERS_CAN_CONTROL_PERMISSIONS:  true
  DEFAULT_USERS_CAN_CREATE_TEXTS:         true
  DEFAULT_USERS_CAN_SEE_OTHERS_WORK:      true
  DEFAULT_USER_GROUP:                     student
  ENVIRONMENT_TAG:                        Development
  GMAIL_PASS:                             gmail_password
  GMAIL_USER:                             gmail_username
  GOOGLE_ANALYTICS_CODE:                  analytics_code
  GOOGLE_VERIFICATION_CODE:               verification_code
  UNICORN_BACKLOG:                        16
  scope:                                  google_api_stuff
  issuer:                                 more_google_api_stuff
  DEVISE_SECRET_KEY:                      super_secret_key
  GLOBAL_ALERT:                           "Global Alert Goes Here. Very important information!"
  ALERT_LEVEL:                            "success"

test:
  DEVISE_SECRET_KEY:                      blah blah
  API_CONSUMER:                           localhost
  API_SECRET:                             heorot-vermonty

EOF