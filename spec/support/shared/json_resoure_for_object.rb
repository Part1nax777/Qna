shared_examples_for 'Return object of resource' do
  it 'return object of resource' do
    expect(json_resource.size).to eq 1
  end
end