# encoding: utf-8

require_relative '../active_support/concern'
require_relative '../active_support/core_ext/object/blank'

module Rkorm
  module Bucket
    extend ::ActiveSupport::Concern

    module ClassMethods
      # @return [bucket] set the bucket
      def set_bucket_name(bucket = nil)
        @bucket = bucket
      end

      def bucket_name
        if @bucket.blank?
          "#{self.to_s.downcase}s"
        else
          @bucket.to_s
        end
      end

      # @params [key, options] get a key value
      # @return [Model] instance
      def get(key, options = {})
        begin
          robject = ::Riak::Bucket.new(::Rkorm::Client.riak, self.bucket_name)
                                  .get(key.to_s, options)
        rescue ::Riak::FailedRequest
          return nil
        end

        new do |obj|
          obj.instance_eval { @is_new = false; self.key = key.to_s }
          if robject.data.is_a? Hash
            robject.data.each_pair {|k, v| obj.instance_variable_set(:"@#{k}", v)}
          else
            obj.instance_variable_set(:@data, robject.data)
          end
        end
      end
    end # ClassMethods

    module InstanceMethods
      def bucket_name
        self.class.bucket_name
      end
    end # InstanceMethods

  end # Bucket
end # Rkorm