module Ultrafast
  class Storage
    def self.redis_connection
      $redis_connection ||= Redis.new(
        host: ENV['UF_REDIS_HOST'] || '127.0.0.1',
        port: ENV['UF_REDIS_PORT'] || 6379,
        db: (ENV['UF_REDIS_DB'] || 0).to_i
      )
    end
  end
end
