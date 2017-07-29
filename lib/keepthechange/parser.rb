require 'strscan'

module KeepTheChange
  class Parser
    HEADER_REGEXP  = /^## \[(\d+\.\d+\.\d+)\] - (\d{4}-\d{2}-\d{2})$/
    SECTION_REGEXP = /^### (.*)$/

    def initialize(changelog)
      @changelog      = changelog
      @changelog_hash = {}
    end

    def parse
      @changelog.scan(HEADER_REGEXP) do |match|
        version_changes = $~.post_match
        scanner         = StringScanner.new(version_changes)
        scanner.scan_until(HEADER_REGEXP)
        version_changes           = parse_version_changes(scanner.pre_match || version_changes)
        @changelog_hash[match[0]] = {
          changes: version_changes,
          date:    match[1],
        }
      end
      @changelog_hash
    end

    private

    def parse_version_changes(changes)
      changes_hash = {}
      changes.scan(SECTION_REGEXP) do |match|
        block_changes = $~.post_match
        scanner       = StringScanner.new(block_changes)
        scanner.scan_until(SECTION_REGEXP)
        changes_hash[match[0]] = (scanner.pre_match || block_changes).gsub(/(\A\n+|\n+\z)/, '')
      end
      changes_hash
    end
  end
end
