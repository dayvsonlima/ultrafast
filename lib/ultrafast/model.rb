module Ultrafast
  module Model
    def fast_create(*attributes)
      uuid = SecureRandom.uuid
      store_key = "#{self.current_application_name}.#{self.name}.create.#{Time.now.to_i}.#{uuid}"
      content = attributes.to_json

      redis_connection.set(store_key, content)
      self.new(attributes)
    rescue => exception
      error_message(exception)
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

    def current_application_name
      Ultrafast::CurrentApplication.name
    end

    def error_message(exception)
      Rails.logger.error exception.backtrace
      Rails.logger.error '-----------------------------------------------------'
      Rails.logger.error '[WARN Error] on try use fastcreate, running fallback'
      Rails.logger.error '-----------------------------------------------------'
    end
  end
end
