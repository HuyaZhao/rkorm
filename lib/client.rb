# encoding: utf-8
require 'riak'
require 'redis'

module Rkorm
  module Client
    def self.riak
      $riak_client ||= ::Riak::Client.new
    end

    def self.riak=(client)
      $riak_client = client
    end

    def self.redis=(client)
      $redis = client
    end

    def self.redis
      $redis ||= ::Redis.new(host: '127.0.0.1', port: 6379)
    end

  end # Client
end # Rkorm