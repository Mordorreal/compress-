require 'rails_helper'

RSpec.describe UploadFileToS3Service do
  # need to disable this cop because we need to use double instead of instance_double
  # rubocop:disable RSpec/VerifiedDoubles
  let(:file) { double(File, content_type: 'image/jpeg', path: 'testpath') }
  # rubocop:enable RSpec/VerifiedDoubles
  let(:aws_object) { instance_double(Aws::S3::Object) }

  before do
    allow(described_class).to receive(:aws_object).and_return(aws_object)
    allow(aws_object).to receive(:upload_file).and_return(true)
    allow(aws_object).to receive(:public_url).and_return('')
    allow(SecureRandom).to receive(:uuid).and_return('uuid')
  end

  it 'generates filename with extension' do
    described_class.call(file)

    expect(described_class).to have_received(:aws_object).with('uuid.jpg')
  end

  it 'overwrites filename with extension' do
    described_class.call(file, filename: 'filename.jpg')

    expect(described_class).to have_received(:aws_object).with('filename.jpg')
  end
end
