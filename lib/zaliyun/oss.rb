require 'zaliyun/oss/version'
require 'zaliyun/oss/struct'
require 'zaliyun/oss/error'

module ZAliyun
  module Oss
    autoload :Utils,            'zaliyun/oss/utils'
    autoload :Client,           'zaliyun/oss/client'
    autoload :Authorization,    'zaliyun/oss/authorization'
  end
end
