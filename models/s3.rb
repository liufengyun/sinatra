class S3
  class << self
    def bucket_name
      Configuration.s3.bucket
    end

    def base_uri
      "http://#{self.bucket_name}.s3.amazonaws.com"
    end

    def object_url(key)
      base_uri + "/" + key
    end

    # generate the policy document that amazon is expecting.
    def policy(person)
      ret = {"expiration" => 30.minutes.from_now.utc.xmlschema,
        "conditions" =>  [
          {"bucket" =>  self.bucket_name},
          ["starts-with", "$key", "company"],
          {"acl" => "public-read"},
          {"success_action_status" => "200"},
          ["content-length-range", 0, 209715300] # 200MB
        ]
      }
      Base64.encode64(ret.to_json).gsub(/\n|\r/, '')
    end

    # sign our request by Base64 encoding the policy document.
    def signature(policy_document)
      Base64.encode64(
        OpenSSL::HMAC.digest(
          OpenSSL::Digest::Digest.new('sha1'),
          Configuration.s3.secret,
          policy_document
        )
      ).gsub(/\n|\r/, '')
    end

    def set_rules
      puts "enable CORS..."
      bucket.cors.clear
      bucket.cors.add(:allowed_methods => %w(GET), :allowed_origins => %w(*), :allowed_headers => %w(*))
      bucket.cors.add(:allowed_methods => %w(PUT POST), :allowed_origins => ["http://#{Configuration.host}", "https://#{Configuration.host}"], :allowed_headers => %w(*))
      puts "done!"
    end

    def bucket
      AWS::S3.new(access_key_id: Configuration.s3.id, secret_access_key: Configuration.s3.secret).buckets[Configuration.s3.bucket]
    end

    def delete_object(key)
      S3.bucket.objects[key].delete
    end
  end
end
