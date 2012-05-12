# encoding: utf-8

require 'minitest/autorun'
require_relative '../lib/key'
require_relative '../lib/bucket'

describe 'Key' do
  before do
    class A
      include ::Rkorm::Key
      include ::Rkorm::Bucket
    end
  end

  it 'key= method' do
    a = A.new
    a.key = 'abc'
    a.instance_variable_get(:@key).must_equal 'abc'
    a.instance_variable_set(:@key, nil)
  end

  it 'key method return @key if @key exist' do
    a = A.new
    a.instance_variable_set(:@key, 'abc')
    a.key.must_equal 'abc'
    a.instance_variable_set(:@key, nil)
  end

  it 'key method return redis result if @key not setting' do
    a = A.new
    a.key.must_equal '1'
    a.instance_variable_get(:@key).wont_be_nil
    ::Rkorm::Client.redis.del("riak:#{a.class.bucket_name}:key")
  end

  it 'method get_riak_key will get result from redis' do
    a = A.new
    a.get_riak_key.must_equal '1'
    a.instance_variable_get(:@key).wont_be_nil
    ::Rkorm::Client.redis.del("riak:#{a.class.bucket_name}:key")
  end


end