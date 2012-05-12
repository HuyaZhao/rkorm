# encoding: utf-8
require 'riak'
require_relative '../active_support/concern'
require_relative 'rkorm/attributes'
require_relative 'bucket'
require_relative 'key'

module Rkorm
  extend ::ActiveSupport::Concern

  included do
    include ::Rkorm::Bucket
    include ::Rkorm::Attributes
    include ::Rkorm::Key
  end



end # Rkorm