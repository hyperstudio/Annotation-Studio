if defined?(RuntimeerrorNotifier)
  # Get your secret email address from RuntimeError.net and
  # 1. Set it as environment variable RUNTIMEERROR_EMAIL (preferred method)
  # 2. OR, change the value (legacy method)
  RuntimeerrorNotifier.for ENV['RUNTIMEERROR_EMAIL']

  RuntimeerrorNotifier::Notifier::IGNORED_EXCEPTIONS.push(*%w[
    ActionController::RoutingError
  ])
end
