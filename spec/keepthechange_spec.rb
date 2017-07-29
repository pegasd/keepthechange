require 'spec_helper'

RSpec.describe Keepthechange do
  it 'has a version number' do
    expect(Keepthechange::VERSION).not_to be nil
  end

  it 'compiles' do
    expect(Keepthechange).to be_kind_of(Module)
  end
end
