module Ultrafast
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
          cursors[model.name], keys = redis_connection.scan(cursor, match: "#{application_name}.#{model}.*", count: 1000)

          keys.each do |key|
            values << JSON.parse(redis_connection.get(key))[0]
          end

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

    def self.application_name
      application_name = Ultrafast::CurrentApplication.name
    end
  end
end
