shared_examples_for 'Return list of' do
  it 'resource of' do
    expect(json_resource.size).to eq 2
  end
end