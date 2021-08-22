defmodule Librecov.Helpers.SentryErrorLogger do
  def log(exception, stacktrace) do
    Sentry.capture_exception(exception, stacktrace: stacktrace)
  end
end
