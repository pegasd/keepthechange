require 'strscan'
require 'sem_version'

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
        @changelog_hash[match[0]] = version_changes
      end
      @changelog_hash
    end

    def combine_changes(since_version, to_version = nil)
      self.parse if @changelog_hash.empty?

      combined_changes = {}
      filtered_changes = @changelog_hash
      if to_version
        filtered_changes.delete_if { |key, _|
          SemVersion.new(key) <= SemVersion.new(since_version) ||
            SemVersion.new(key) > SemVersion.new(to_version)
        }
      else
        filtered_changes.delete_if { |key, _| SemVersion.new(key) <= SemVersion.new(since_version) }
      end

      filtered_changes.each do |_, changes|
        changes.each do |section, changes_list|
          if combined_changes.key? section
            combined_changes[section] << "\n" << changes_list
          else
            combined_changes[section] = changes_list
          end
        end
      end

      output = "## Changes since [#{since_version}]"
      output << " (and up to [#{to_version}])" if to_version

      combined_changes.each do |section, changes_list|
        output << "\n\n### #{section}"
        output << "\n#{changes_list}"
      end

      output << "\n"
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
