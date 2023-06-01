Aws.config.update({
                    region: 'ap-southeast-1',
                    credentials: Aws::Credentials.new(ENV.fetch('AWS_ACCESS_KEY_ID', nil),
                                                      ENV.fetch('AWS_SECRET_ACCESS_KEY', nil))
                  })

S3_BUCKET = Aws::S3::Resource.new.bucket(ENV.fetch('S3_BUCKET', nil))
S3_CLIENT = Aws::S3::Client.new
if Rails.env.production?
  S3_HOST = '//phuketmanage.s3-ap-southeast-1.amazonaws.com/'
else
  S3_HOST = '//phuketmanage-development.s3-ap-southeast-1.amazonaws.com/'
  S3_HOST_SHORT = 'phuketmanage.s3-ap-southeast-1.amazonaws.com/'
end
# URI.parse(@s3_direct_post.url).host
