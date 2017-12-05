require 'zaliyun/oss/xml_generator'
# Function Based
require 'zaliyun/oss/api/buckets'
require 'zaliyun/oss/api/bucket_property'
require 'zaliyun/oss/api/bucket_objects'
require 'zaliyun/oss/api/bucket_multiparts'
# Object Based
require 'zaliyun/oss/client/clients'

require 'zaliyun/oss/http'

module ZAliyun
  module Oss
    class Client
      include ZAliyun::Oss::Api::Buckets
      include ZAliyun::Oss::Api::BucketProperty
      include ZAliyun::Oss::Api::BucketObjects
      include ZAliyun::Oss::Api::BucketMultiparts

      attr_reader :access_key, :secret_key, :bucket

      # Initialize a object
      #
      # @example
      #   ZAliyun::Oss::Client.new("ACCESS_KEY", "SECRET_KEY", host: "oss-cn-beijing.aliyuncs.com", bucket: 'oss-sdk-beijing')
      #
      # @param access_key [String] access_key obtained from aliyun
      # @param secret_key [String] secret_key obtained from aliyun
      # @option options [String] :host host for bucket's data center
      # @option options [String] :bucket Bucket name
      #
      # @return [Response]
      def initialize(access_key, secret_key, options = {})
        @access_key = access_key
        @secret_key = secret_key
        @options = options
        @bucket = options[:bucket]

        @services = {}
      end

      private

      def http
        @http ||= Http.new(access_key, secret_key, @options[:host])
      end
    end
  end
end
