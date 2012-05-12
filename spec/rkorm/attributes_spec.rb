# encoding: utf-8
require 'minitest/autorun'
require_relative '../../lib/rkorm'


describe "Attributes" do
  before do
    class Attr
      include ::Rkorm::Attributes
    end
    class A
      include ::Rkorm::Attributes
      property :attr1
      property :attr2
      property :attr3
    end
  end

  describe 'ClassMethods' do

    it 'class has property class method' do
      Attr.respond_to?(:property).must_equal true
    end
    it 'class has @attrs_array instance_variable' do
      Attr.__send__(:property, :username)
      Attr.instance_variables.must_include :@attrs_array
      Attr.instance_variable_get(:@attrs_array).size.must_equal 1

      Attr.__send__(:property, :email)
      Attr.instance_variable_get(:@attrs_array).size.must_equal 2
    end
    it 'attributes method to make' do
      Attr.__send__(:property, :username)
      Attr.instance_methods.must_include :username
      Attr.instance_methods.must_include :username=
    end

    it 'property_protected' do
      A.__send__(:property_protected, :attr2)
      A.instance_variable_defined?(:@protected_properties).must_equal true
      A.instance_methods.must_include :attr2
      A.instance_methods.wont_include :attr2=
      A.new.respond_to?(:attr2=).must_equal false
      A.instance_variable_set(:@protected_properties, [])
    end # method property_protected

    it 'get_protected_properties' do
      A.__send__(:get_protected_properties).length.must_equal 0
    end # get_protected_properties

    it 'get_protected_properties not empty' do
      A.__send__(:property_protected, :attr2)
      A.__send__(:get_protected_properties).length.must_equal 1
      A.instance_variable_get(:@protected_properties).must_include :attr2
      A.instance_variable_set(:@protected_properties, [])
    end # get_protected_properties

    it 'content_type' do
      A.instance_eval { content_type 'application/json' }
      A.instance_variable_defined?(:@content_type).must_equal true
      A.instance_variable_get(:@content_type).must_equal 'application/json'
      A.instance_variable_set(:@content_type, nil)
    end # content_type

    it 'get_content_type' do
      A.__send__(:get_content_type).must_be_nil
      A.instance_eval { content_type 'application/text' }
      A.__send__(:get_content_type).must_equal 'application/text'
    end # get_content_type

    it 'get_all_property' do
      A.__send__(:get_all_property)
      A.instance_variable_defined?(:@attrs_array).must_equal true
      A.instance_variable_get(:@attrs_array).length.must_equal 3
    end

  end # ClassMethods


end
