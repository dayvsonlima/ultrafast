require 'securerandom'
require 'ultrafast/version'
require 'redis'
require './ultrafast/current_application'
require './ultrafast/storage'
require './ultrafast/model'
require './ultrafast/server'

module Ultrafast
  class Error < StandardError; end

  class CurrentApplication
    def self.name
      Rails.application.class.parent_name
    end
  end
end
