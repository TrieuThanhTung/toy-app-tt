class RedisService
  NAMESPACE = "session_toy"
  class << self
    def set(key, value)
      $redis.set get_key(key), value
      expire key
    end

    def get(key)
      $redis.get get_key(key)
    end

    def delete(key)
      $redis.del get_key(key)
    end

    def exists?(key)
      $redis.exists get_key(key)
    end

    private
    def expire(key)
      $redis.expire "#{NAMESPACE}:#{key}", 1.day
    end

    def get_key(key)
      "#{NAMESPACE}:#{key}"
    end
  end
end
