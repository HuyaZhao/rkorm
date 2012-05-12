$:.push File.expand_path('../lib', __FILE__)
require 'rkorm/version'

Gem::Specification.new do |gem|
  gem.name = "rkorm"
  gem.version = Rkorm::VERSION
  gem.summary = %Q{rkorm is a very sample model document.}
  gem.description = %Q{rkorm is a very sample model document for riak.}
  gem.email = ["tentcents@qq.com"]
  gem.homepage = "http://github.com/HuyaZhao/rkorm"
  gem.authors = ['HuyaZhao']

  gem.add_development_dependency "riak-client", "~>1.0.3"
  gem.add_development_dependency "redis", "~>2.2.2"

  gem.require_paths = ['lib']
end