module Ultrafast
  module Model
    def fast_create(*attributes)
      uuid = SecureRandom.uuid
      store_key = "#{self.current_application_name}.#{self.name}.create.#{Time.now.to_i}.#{uuid}"
      content = attributes.to_json

      redis_connection.set(store_key, content)
      self.new(attributes)
    rescue
      error_message
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

    def error_message
      Rails.logger.warn '-----------------------------------------------------'
      Rails.logger.warn '[WARN Error] on try use fastcreate, running fallback'
      Rails.logger.warn '-----------------------------------------------------'
    end
  end
end
