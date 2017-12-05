## Multipart Upload

Besides simple upload via put, OSS provide another way to upload large file -- Multipart Upload, Here we list some normal application scenarios:

+ To support breakpoint upload
+ Upload file large than 100 MB
+ Network is bad, and the connection between the OSS server often disconnected
+ Upload a file before, unable to determine the size of the uploaded files


Now, Let's start party!


### Initialize

Before start a Multipart Upload, we need first initialize a event:

    
    require 'aliyun/oss'
    
    access_key, secret_key = "your id", "your secret"
    host = "oss-cn-hangzhou.aliyuncs.com"
    bucket = "bucket-name"
    client = ZAliyun::Oss::Client.new(access_key, secret_key, host: host, bucket: bucket)
    
    begin
    # Step-1 Init a Multipart Upload
      multipart = client.bucket_multiparts.init("Exciting-Ruby.mp4", { 'Content-Type' => 'video/mp4' })
      puts "Upload ID: #{multipart.upload_id}"
    rescue ZAliyun::Oss::RequestError => e
      puts "Init Multipart fail", e.code, e.message, e.request_id
    end
    
Upload ID is the UUID for the Multipart Upload Event, store it for use later.

### Upload Part from local 

    require 'aliyun/oss'
    
    access_key, secret_key = "your id", "your secret"
    host = "oss-cn-hangzhou.aliyuncs.com"
    bucket = "bucket-name"
    client = ZAliyun::Oss::Client.new(access_key, secret_key, host: host, bucket: bucket)
    
    begin
      multipart = client.bucket_multiparts.init("Exciting-Ruby.mp4", { 'Content-Type' => 'video/mp4' })
      headers = multipart.upload("Exciting-Ruby.mp4", 1, file_or_bin)
      puts "etag: #{headers['etag']}"
    rescue ZAliyun::Oss::RequestError => e
      puts "Upload to Multipart fail", e.code, e.message, e.request_id
    end

Store the etag, it will used for complete a Multipart Upload.

It can used to upload part to a object. Please note:

+ Multipart Upload requirements every parts greater than 100 KB except last
+ In order to ensure that data safe when network transmission, strongly recommend to include meta: content-md5, after receiving the data, OSS using the md5 value to prove the validity of the upload data, if they are inconsistent returns InvalidDigest.
+ The Part number range is 1~10000. If beyond this range, the OSS will return InvalidArgument.
+ If you upload from the same file, be careful for the upload position

### Complete Multipart Upload

    require 'aliyun/oss'
    
    access_key, secret_key = "your id", "your secret"
    host = "oss-cn-hangzhou.aliyuncs.com"
    bucket = "bucket-name"
    client = ZAliyun::Oss::Client.new(access_key, secret_key, host: host, bucket: bucket)
    
    part1 = ZAliyun::Oss::Struct::Part.new({ number: 1, etag: 'etag1' })
	part2 = ZAliyun::Oss::Struct::Part.new({ number: 2, etag: 'etag2' })
	part3 = ZAliyun::Oss::Struct::Part.new({ number: 3, etag: 'etag3' })
	begin
	  multipart.complete([part1, part2, part3])
	rescue ZAliyun::Oss::RequestError => e
      puts "Complete Multipart fail", e.code, e.message, e.request_id
    end
	

Here, we create ZAliyun::Oss::Struct::Part to build your part, use Part#valid? to valid the object.

### Abort Multipart Upload

If some Problem occurs, you may want to abort a Multipart Upload:

    require 'aliyun/oss'
    
    access_key, secret_key = "your id", "your secret"
    host = "oss-cn-hangzhou.aliyuncs.com"
    bucket = "bucket-name"
    client = ZAliyun::Oss::Client.new(access_key, secret_key, host: host, bucket: bucket)
    
    begin
      multipart.abort
    rescue ZAliyun::Oss::RequestError => e
      puts "Upload to Multipart fail", e.code, e.message, e.request_id
    end
    
After abort a multipart, all uploaded parts will be destroyed, But Note: If some others are upload parts to this object when your abort, they may be missing, so invoke a few times if you have access in concurrent.

### List Multipart Upload

To get all Multipart Upload in this Bucket:

    require 'aliyun/oss'
    
    access_key, secret_key = "your id", "your secret"
    host = "oss-cn-hangzhou.aliyuncs.com"
    bucket = "bucket-name"
    client = ZAliyun::Oss::Client.new(access_key, secret_key, host: host, bucket: bucket)
    
    multiparts = client.bucket_multiparts.list

Same with all other list method, it support prefix, delimiter, marker to get flexible results.


### List Uploaded Parts

Sometimes, you want to know which parts are uploaded.

    require 'aliyun/oss'
    
    access_key, secret_key = "your id", "your secret"
    host = "oss-cn-hangzhou.aliyuncs.com"
    bucket = "bucket-name"
    client = ZAliyun::Oss::Client.new(access_key, secret_key, host: host, bucket: bucket)
    
    parts = multipart.list_parts


OK, It's time to visit [CORS](./cors.md)    
    
