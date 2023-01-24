class AWSS3
  AWS_REGION = 'eu-central-1'.freeze
  AWS_CREDENTIALS =
    Aws::Credentials.new(
      ENV.fetch('AWS_ACCESS_KEY_ID') { '' },
      ENV.fetch('AWS_SECRET_ACCESS_KEY') { '' },
    ).freeze
  S3_RESOURCE =
    Aws::S3::Resource.new(
      credentials: AWS_CREDENTIALS,
      region: AWS_REGION,
    ).freeze

  BUCKET_NAME = 'compress--bucket'.freeze
  DOWNLOAD_FOLDER = Rails.root.join('/tmp/').freeze
end
