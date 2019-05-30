module Ultrafast
  class Server
    def self.start
      start_message
      Rails.application.eager_load!

      cursors = {}

      loop do
        list_models.each do |model|
          keys = []
          cursor = cursors[model.name] rescue 0
          cursors[model.name], keys = get_redis_page(model, cursor)

          values = keys.map{|key| JSON.parse(redis_connection.get(key))[0] }

          if values.count > 0
            model.import(values)
            keys.each{|key| redis_connection.del(key) }
          end
        end

        sleep(sleep_time)
      end
    end

    def self.get_redis_page(model, cursor)
      redis_connection.scan(
        cursor,
        match: "#{application_name}.#{model}.*",
        count: model.fast_default_amount
      )
    end

    def self.redis_connection
      Ultrafast::Storage.redis_connection
    end

    def self.application_name
      Ultrafast::CurrentApplication.name
    end

    def self.list_models
      ActiveRecord::Base.descendants.select{|model| model.try(:has_fast_create) }
    end

    def self.start_message
      Rails.logger.info '-----------------------------------------------------'
      Rails.logger.info '[START ULTRAFAST] Ultrafast server is started'
      Rails.logger.info '-----------------------------------------------------'
    end

    def self.sleep_time
      (ENV['UF_LOOP_INTERVAL'] || 0.5).to_f
    end
  end
end
