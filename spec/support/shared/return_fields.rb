shared_examples_for 'Return fields' do
  it 'all public fields' do
    fields.each do |attr|
      expect(resource_response[attr]).to eq resource_name.send(attr).as_json 
    end
  end
end