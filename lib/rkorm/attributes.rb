# encoding: utf-8

require_relative '../../active_support/concern'
require_relative '../client'

module Rkorm
  module Attributes
    extend ::ActiveSupport::Concern

    module ClassMethods
      def property(attr_name, type = nil, options = {})
        attr_name = attr_name.to_sym
        @attrs_array ||= []
        @attrs_array.push(attr_name) unless @attrs_array.include?(attr_name)
        self.class_eval <<-CODE
          def #{attr_name}
            @#{attr_name}
          end

          def #{attr_name}=(value)
            @#{attr_name} = value
          end
        CODE
      end

      def property_protected(*property)
        @protected_properties = property.map &:to_sym

        property.each do |p_method|
          remove_method :"#{p_method}="
        end
      end

      def get_protected_properties; @protected_properties ||= []; end
      def content_type(type); @content_type = type.to_s; end
      def get_content_type; @content_type; end
      def get_all_property; @attrs_array ||= []; end

    end # ClassMethods

    module InstanceMethods
      #
      def initialize(options = {})
        raise 'options must be hash' unless options.is_a? Hash
        options = options.symbolize_keys
        property_keys = options.keys

        (self.class.get_all_property - self.class.get_protected_properties).each do |property|
          if property_keys.include?(property)
            self.__send__("#{property}=", options[property])
          else
            self.__send__("#{property}=", nil)
          end
        end

        @links = []
        @is_new = true
        yield self if block_given?
      end

      def attributes
        attrs_to_hash = {}
        self.class.get_all_property.each do |k|
          attrs_to_hash[k] = self.__send__(k)
        end
        attrs_to_hash
      end


      def riak_client
        ::Rkorm::Client.riak
      end

      def content_type=(type)
        @content_type = type
      end

      def content_type
        if type = self.class.get_content_type
          @content_type = type
        else
          @content_type
        end
      end

      def data=(data);@data = data;end
      def data;@data;end
      def raw_data=(data);@raw_data = data;end
      def raw_data;@raw_data;end
      def get_all_links; @links; end

      # @params[bucket]
      # @params[key]
      # @params[tag]
      # links(bucket, key, tag)
      def links(*options)
        @links.push ::Riak::Link.new(*options)
        self
      end

      def save
        bucket = self.riak_client.bucket self.bucket_name

        new_one = ::Riak::RObject.new(bucket, self.key).tap do |ro|
          ro.content_type = self.content_type || 'application/json'
          if self.raw_data
            ro.raw_data = self.raw_data
          else
            ro.data = self.data || self.attributes
          end

          unless self.get_all_links.empty?
            ro.links = self.get_all_links
          end
        end
        new_one.store
        @is_new = false
        self
      end

      def delete(options = {})
        self.riak_client.delete_object(self.bucket_name, self.key, options)
        freeze
      end

    end # InstanceMethods


  end # Attributes
end # Rkorm