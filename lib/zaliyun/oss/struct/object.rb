module ZAliyun
  module Oss
    module Struct
      class Object < Base
        # Key of object
        attr_accessor :key

        # last modified time of object
        attr_accessor :last_modified

        # etag of object
        attr_accessor :etag
        alias_method :e_tag=, :etag=

        # type of object
        attr_accessor :type

        # size of object
        attr_accessor :size

        # storage class of object
        attr_accessor :storage_class

        # owner of object
        attr_accessor :owner

        # location of object
        attr_accessor :location

        # bucket of object placed
        attr_accessor :bucket

        # reference to client
        attr_accessor :client

        # Get ACL for object
        #
        # @raise [RequestError]
        #
        # @return [String]
        def acl!
          result = client.bucket_get_object_acl(key).parsed_response
          acl_keys = %w(AccessControlPolicy AccessControlList Grant)
          Utils.dig_value(result, *acl_keys).strip
        end

        # Set ACL for object
        #
        # @param acl [String] access value, supported value: private, public-read, public-read-write
        #
        # @raise [RequestError]
        #
        # @return [true]
        def set_acl(acl)
          !!client.bucket_set_object_acl(key, acl)
        end

        # Get meta information of object
        #
        # @param headers [Hash] headers
        # @option (see #bucket_get_meta_object)
        #
        # @raise [RequestError]
        #
        # @return [HTTParty::Response::Headers]
        def meta!(*args)
          client.bucket_get_meta_object(*args.unshift(key)).headers
        end

        class << self
          def init_from_response(result, keys, client)
            Utils.wrap(Utils.dig_value(result, *keys)).map do |object|
              init_from_object(object, client)
            end
          end

          def init_from_object(object, client)
            if object.key?('Key') && object['Key'].end_with?('/')
              Struct::Directory.new(object.merge(client: client))
            elsif object.key?('Prefix') && object['Prefix'].end_with?('/')
              Struct::Directory.new(object.merge(client: client))
            else
              Struct::File.new(object.merge(client: client))
            end
          end
        end
      end
    end
  end
end

require 'zaliyun/oss/struct/file'
require 'zaliyun/oss/struct/directory'
