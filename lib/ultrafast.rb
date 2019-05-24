require 'securerandom'
require 'ultrafast/version'
require 'redis'

module Ultrafast
  class Error < StandardError; end

  module Model
    def fast_create(*attributes)
      uuid = SecureRandom.uuid
      store_key = "#{self.name}.create.#{Time.now.to_i}.#{uuid}"
      content = attributes.to_json

      redis_connection.set(store_key, content)
    rescue
      Rails.logger.warn '-----------------------------------------------------'
      Rails.logger.warn '[WARN Error] on try use fastcreate, running fallback'
      Rails.logger.warn '-----------------------------------------------------'
      self.create(*attributes)
    end

    def has_fast_create
      true
    end

    def fast_default_amount
      100
    end

    def redis_connection
    	Ultrafast::Storage.redis_connection
    end
  end

  class Storage
    def self.redis_connection
      $redis_connection ||= Redis.new(
  		  host: ENV['UF_REDIS_HOST'] || '127.0.0.1',
  		  port: ENV['UF_REDIS_PORT'] || 6379
    	)
    end
  end

  class Server
    def self.start
      Rails.logger.info '-----------------------------------------------------'
      Rails.logger.info '[START ULTRAFAST] Ultrafast server is started'
      Rails.logger.info '-----------------------------------------------------'

      redis_connection = Ultrafast::Storage.redis_connection

      Rails.application.eager_load!
      models = ActiveRecord::Base.descendants.select{|model| model.try(:has_fast_create) }
      cursors = {}

      loop do
        models.each do |model|
          values = []
          keys = []
          cursor = cursors[model.name] rescue 0
          cursors[model.name], keys = redis_connection.scan(cursor, match: "#{model}.*", count: 1000)

          keys.each { |key| values << JSON.parse(redis_connection.get(key))[0] }

          if values.count > 0
            model.import(values)
            keys.each{|key| redis_connection.del(key) }
          end
        end

        sleep_time = ENV['UF_LOOP_INTERVAL'] || 0.5
        sleep(sleep_time.to_f)
      end
    end

    def self.redis_connection
      Ultrafast::Storage.redis_connection
    end
  end
end
