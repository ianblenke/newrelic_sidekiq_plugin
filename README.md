## New Relic Sidekiq Plugin

This plugin reports statistics from Sidekiq to NewRelic such as:

- Job processing rates
- Queue sizes and latency

### Requirements

Ruby

### Installing

`sudo gem install newrelic_sidekiq_plugin`

### Configuring

Create a `newrelic_plugin.yml` file using `config/template_newrelic_plugin.yml`
as an example.

### Running

See `newrelic_sidekiq_plugin -h`

Use a process manager such as `upstart` to keep the process running.

## Support

Please use Github issues for support.
