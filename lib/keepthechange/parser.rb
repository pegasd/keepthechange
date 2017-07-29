require 'strscan'

module KeepTheChange
  class Parser
    VERSION_HEADER_RE = /^## \[(\d+\.\d+\.\d+)\] - (\d{4}-\d{2}-\d{2})$/.freeze
    SECTION_HEADER_RE = /^### (.*)$/.freeze

    def initialize(changelog: '', version_header_re: VERSION_HEADER_RE, section_header_re: SECTION_HEADER_RE)
      @changelog         = changelog
      @version_header_re = version_header_re
      @section_header_re = section_header_re
      @changelog_hash    = {}
    end

    def parse
      @changelog.scan(@version_header_re) do |match|
        version_changes = $~.post_match
        scanner         = StringScanner.new(version_changes)
        scanner.scan_until(@version_header_re)
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
      changes.scan(@section_header_re) do |match|
        block_changes = $~.post_match
        scanner       = StringScanner.new(block_changes)
        scanner.scan_until(@section_header_re)
        changes_hash[match[0]] = (scanner.pre_match || block_changes).gsub(/(\A\n+|\n+\z)/, '')
      end
      changes_hash
    end
  end
end
