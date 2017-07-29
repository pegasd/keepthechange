require 'spec_helper'

RSpec.describe KeepTheChange do
  it 'has a version number' do
    expect(KeepTheChange::VERSION).not_to be nil
  end

  it 'compiles' do
    expect(KeepTheChange).to be_kind_of(Module)
  end

  it 'can parse a simple Changelog' do
    parser = KeepTheChange::Parser.new(<<~MARKDOWN
      ## [0.1.0] - 2017-07-17
      ### Added
      - Luke
    MARKDOWN
    )

    expect(parser.parse).to eq({
      '0.1.0' => {
        changes: {
          'Added' => '- Luke'
        },
        date: '2017-07-17'
      }
    })
  end
end
