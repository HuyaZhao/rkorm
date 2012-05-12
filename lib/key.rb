# encoding: utf-8

require 'redis'
require_relative 'client'
require_relative '../active_support/concern'

module Rkorm
  module Key
    extend ::ActiveSupport::Concern

    module InstanceMethods

      def key=(key)
        @key = key
      end

      def key
        @key ? @key : self.get_riak_key
      end

      def get_riak_key
        self.key = ::Rkorm::Client.redis
                                  .incr("riak:#{self.class.bucket_name}:key")
                                  .to_s
      end

    end # InstanceMethods



  end # Key
end # Rkorm