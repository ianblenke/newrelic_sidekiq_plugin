#!/bin/bash
export BUNDLE_GEMFILE=/usr/src/app/Bundle.Gemfile

cd /usr/src/app

cat <<EOF > /usr/src/app/config/newrelic_plugin.yml
# Please make sure to update the license_key information with the license key for your New Relic
# account.
#
#
newrelic:
  #
  # Update with your New Relic account license key:
  #
  license_key: '$NEWRELIC_LICENSE_KEY'
  #
  # Set to '1' for verbose output, remove for normal output.
  # All output goes to stdout/stderr.
  #
  #verbose: 1

  # Proxy configuration:
  #proxy:
  #  address: localhost
  #  port: 8080
  #  user: nil
  #  password: nil

#
# Agent Configuration:
#
agents:
  # this is where configuration for agents belongs
  sidekiq:
  - uri: $REDISTOGO_URL
    name: $NAME
    namespace: "$NAMESPACE" # if you are namespacing
EOF

exec bundle exec foreman start
