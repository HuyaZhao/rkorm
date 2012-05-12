# `rkorm`: it's very sample for riak document models

**NOTE**: it need install redis server and (`redis`) gem.


## Dependencies

`rkorm`   it also depends on the `riak-client` gem.so you must gem install riak-client.


## Document Model Examples

``` ruby
class User
  include Rkorm
  property :id
  property :name
  property :email
end

user = User.new
user.id = 1
user.name = 'test'
user.email = 'test@test.com'
user.save

# also in initialize
user = User.new id: 1, name: 'test', email: 'test@test.com'
user.save

# set riak bucket
class Account
  include ::Rkorm

  set_bucket_name :accounts
end

# set model attributes
class Account
  include ::Rkorm

  set_bucket_name :accounts
  property :email
  property :password
end

# if you has protected attributes
class Account
  include ::Rkorm

  set_bucket_name :accounts
  property :email
  property :salt
  property :encrypt_password
  property_protected :salt, :encrypt_password
end
account = Account.new
account.salt = 123456 # has no password= method.

#
class Image
  include ::Rkorm

  set_bucket_name :images
  content_type 'image/jpeg'
end

image = Image.new do |image|
    image.raw_data = File.read('xxx.jpg')
end


# riak links
user = User.new do |u|
   u.id = 1
   u.name = 'test'
   u.email = 'test@test.com'
   u.links(bucket, key, tags).links(other_bucket, other_key, other_tags)
end
user.save

# riak get object
user = User.get(key)
user.id   # => 1
user.name # => 'test'
user.name = 'test modify'
user.save

# riak delete object
user = User.get(key)
user.delete

```



## License & Copyright

Copyright 2012 HuyaZhao.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

[http://www.apache.org/licenses/LICENSE-2.0](http://www.apache.org/licenses/LICENSE-2.0)

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

All of the files in this project are under the project-wide license
unless they are otherwise marked.

