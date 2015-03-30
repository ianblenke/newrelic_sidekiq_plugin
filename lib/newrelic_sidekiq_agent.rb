require 'uri'
require 'cgi'

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
lib = File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "newrelic_plugin"
require 'sidekiq'
require 'sidekiq/api'

module NewRelicSidekiqPlugin
  VERSION = '0.1.0'

  class Agent < NewRelic::Plugin::Agent::Base
    agent_guid "com.modcloth.newrelic_plugin.sidekiq"
    agent_version ::NewRelicSidekiqPlugin::VERSION
    agent_config_options :name, :uri, :namespace
    agent_human_labels("Sidekiq") do
      u = ::URI.parse(uri)
      name || "#{u.host}:#{u.port}"
    end

    def setup_metrics
      Sidekiq.configure_server do |config|
        if namespace && namespace.length > 0
          config.redis = { url: uri, namespace: namespace }
        else
          config.redis = ConnectionPool.new(:size => 1, :timeout => 1) do
            Redis.new(url: uri)
          end
        end
      end
      @jobs_failed    = NewRelic::Processor::EpochCounter.new
      @jobs_processed = NewRelic::Processor::EpochCounter.new
    end

    def poll_cycle
      stats   = Sidekiq::Stats.new
      workers = Sidekiq::Workers.new

      report_metric 'Workers/Working', 'Workers', workers.size || 0

      report_metric 'Jobs/Cardinality/Enqueued',  'Jobs',     stats.enqueued || 0
      report_metric 'Jobs/Cardinality/Processed', 'Jobs',     stats.processed || 0
      report_metric 'Jobs/Cardinality/Failed',    'Jobs',     stats.failed || 0
      report_metric 'Jobs/Cardinality/Scheduled', 'Jobs',     stats.scheduled_size || 0
      report_metric 'Jobs/Cardinality/Retries',   'Jobs',     stats.retry_size || 0

      report_metric 'Jobs/Rate/Processed',  'Jobs/sec', @jobs_processed.process(stats.processed || 0)
      report_metric 'Jobs/Rate/Failed',     'Jobs/sec', @jobs_failed.process(stats.failed || 0)

      stats.queues.each do |name, enqueued|
        report_metric "Queues/Enqueued/#{name}", 'Jobs',    enqueued || 0
        report_metric "Queues/Latency/#{name}",  'Latency', Sidekiq::Queue.new(name).latency || 0
      end
    end
  end

  def self.run
    NewRelic::Plugin::Config.config.agents.keys.each do |agent|
      NewRelic::Plugin::Setup.install_agent agent, self
    end

    NewRelic::Plugin::Run.setup_and_run
  end
end
