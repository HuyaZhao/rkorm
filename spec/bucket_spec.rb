# encoding: utf-8
require 'riak'
require 'minitest/autorun'
require_relative '../lib/rkorm'

describe 'Bucket' do
  before do
    class A
      include ::Rkorm::Bucket
    end
    class B;end
    class User
      include ::Rkorm
      set_bucket_name :users
      property :email
    end
  end

  describe 'ClassMethods' do
    it 'class methods for set_bucket_name' do
      A.respond_to?(:set_bucket_name).must_equal true
      A.__send__(:set_bucket_name, 'abc')
      A.instance_variable_get(:@bucket).must_equal 'abc'
      A.instance_variable_set(:@bucket, nil)
    end # set_bucket_name

    it 'class methods for bucket_name' do
      A.respond_to?(:bucket_name).must_equal true
      A.bucket_name.must_equal 'as'

      A.__send__(:set_bucket_name, 'abc')
      A.bucket_name.must_equal 'abc'
    end # bucket_name

    it 'class methods for get' do
      newuser = User.new email: 'test@test.com'
      newuser.save

      user = User.get newuser.key
      user.instance_of?(User).must_equal true
      user.instance_variable_get(:@email).must_equal 'test@test.com'
      user.instance_variable_get(:@is_new).must_equal false
    end # get

    it 'get data if is not hash' do
      newuser = User.new
      newuser.data = 'for test'
      newuser.save

      user = User.get newuser.key
      user.instance_of?(User).must_equal true
      user.instance_variable_get(:@email).must_be_nil
      user.instance_variable_get(:@data).must_equal 'for test'
      user.instance_variable_get(:@is_new).must_equal false
    end # get

    it 'if get nothing,will return nil' do
      user = User.get '00000'
      user.must_be_nil
    end # get

  end # ClassMethods

  describe 'InstanceMethods' do
    it 'instance method for bucket_name' do
      B.__send__(:include, ::Rkorm::Bucket)
      b = B.new
      b.bucket_name.must_equal 'bs'
    end # bucket_name
  end # InstanceMethods

end # Bucket