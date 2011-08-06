# Define it as a plain constant instead of Bundler best-practice of
# Serious::VERSION since Serious is a class that inherits from Sinatra::Base
# and we'd be getting Superclass mismatch errors here since Sinatra is
# unavailable when evaluating this file standalone...
SERIOUS_VERSION = '0.3.2'