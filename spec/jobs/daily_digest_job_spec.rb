require 'rails_helper'

RSpec.describe DailyDigestJob, type: :job do
  let(:service) { double('Services::DailyDigest') }

  before do
    allow(Services::DailyDigest).to receive(:new).and_return(service)
  end

  it 'calls Service::DailyDigest#call' do
    expect(service).to receive(:call)
    DailyDigestJob.perform_now
  end
end
