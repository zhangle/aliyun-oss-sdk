module ZAliyun
  module Oss
    module Struct
      class Base
        def initialize(attributes = {})
          attributes.each do |key, value|
            m = "#{Utils.underscore(key)}=".to_sym
            send(m, value) if self.respond_to?(m)
          end
        end
      end
    end
  end
end

require 'zaliyun/oss/struct/bucket'
require 'zaliyun/oss/struct/object'
require 'zaliyun/oss/struct/multipart'

require 'zaliyun/oss/struct/cors'
require 'zaliyun/oss/struct/lifecycle'
require 'zaliyun/oss/struct/referer'
require 'zaliyun/oss/struct/website'
require 'zaliyun/oss/struct/logging'

require 'zaliyun/oss/struct/part'
