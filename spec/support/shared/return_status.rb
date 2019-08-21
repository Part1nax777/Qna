shared_examples_for 'Return status 200' do
  it 'response status 200' do
    expect(response).to be_successful
  end
end