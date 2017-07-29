require 'spec_helper'

RSpec.describe KeepTheChange::Parser do
  it 'can parse a simple Changelog' do
    parser = KeepTheChange::Parser.new(changelog: <<~MD
      ## [1.0.0] - 2017-07-17
      ### Added
      - Luke
    MD
    )

    expect(parser.parse).to eq({
      '1.0.0' => {
        changes: {
          'Added' => '- Luke'
        },
        date:    '2017-07-17'
      }
    })
  end

  it 'can parse Changelog with setext-style headers using custom RE' do
    parser = KeepTheChange::Parser.new(version_header_re: /^\[(\d+\.\d+\.\d+)\] - (\d{4}-\d{2}-\d{2})\n-+$/, changelog: <<~MD
      [0.2.0] - 2017-06-13
      --------------------
      ### Added
      - Awesome feature #1
      - Awesome feature #2

      ### Fixed
      - A very serious issue has been resolved.
      - Fixed another very serious issue.
      - Smaller fixes.

      [0.1.1] - 2017-06-09
      --------------------
      ### Fixed
      - A bugfix.
      - Another bugfix.

      [0.1.0] - 2017-06-02
      --------------------
      ### Added
      - Lots of shiny new features.
    MD
    )

    expect(parser.parse).to eq({
      '0.2.0' => {
        changes: {
          'Added' => "- Awesome feature #1\n- Awesome feature #2",
          'Fixed' => "- A very serious issue has been resolved.\n- Fixed another very serious issue.\n- Smaller fixes.",
        },
        date:    '2017-06-13'
      },
      '0.1.1' => {
        changes: {
          'Fixed' => "- A bugfix.\n- Another bugfix."
        },
        date:    '2017-06-09'
      },
      '0.1.0' => {
        changes: {
          'Added' => '- Lots of shiny new features.'
        },
        date:    '2017-06-02'
      }
    })
  end
end
