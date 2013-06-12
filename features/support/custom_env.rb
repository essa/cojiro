require File.join(Rails.root, "spec", "support", "url_options_patch.rb")

# for testing sign-in through Twitter, Facebook, etc.
OmniAuth.config.test_mode = true

Before do
  I18n.locale = nil
end

# ref: https://github.com/thoughtbot/capybara-webkit/issues/84 
def handle_js_confirm(accept=true)
  page.evaluate_script "window.original_confirm_function = window.confirm"
  page.evaluate_script "window.confirm = function(msg) { return #{!!accept}; }"
  yield
ensure
  page.evaluate_script "window.confirm = window.original_confirm_function"
end

def wait_until
  require "timeout"
  Timeout.timeout(Capybara.default_wait_time) do
    sleep(0.1) until value = yield
    value
  end
end
