require 'spec_helper'

RSpec.describe KeepTheChange do
  it 'has a version number' do
    expect(Gem::Specification.load('keepthechange.gemspec').version).not_to be_nil
  end

  it 'compiles and is a module' do
    expect(KeepTheChange).to be_kind_of(Module)
  end

  it 'has a class KeepTheChange::Parser' do
    expect(KeepTheChange::Parser).to be_kind_of(Class)
  end
end
