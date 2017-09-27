require 'strscan'
require 'sem_version'

# Parse Changelogs
module KeepTheChange
  # Changelog Parser class. Use a separate instance for each Changelog.
  class Parser
    # Version header RE (these are searched for in the Changelog to find actual versions)
    VERSION_HEADER_RE = /^## \[(\d+\.\d+\.\d+)\] - (\d{4}-\d{2}-\d{2}).*$/
    # Section header RE (these are searched inside each version changeset to find sections)
    SECTION_HEADER_RE = /^### (.*)$/

    # @param [String] changelog Markdown contents of Changelog to be parsed.
    # @param [Regexp] version_header_re Custom header RE.
    # @param [Regexp] section_header_re Custom section RE.
    #
    # @return [KeepTheChange::Parser] Ready to parse!
    def initialize(changelog: '', version_header_re: VERSION_HEADER_RE, section_header_re: SECTION_HEADER_RE)
      @changelog         = changelog
      @version_header_re = version_header_re
      @section_header_re = section_header_re
      @changelog_hash    = {}
    end

    # Parse the Changelog and return a hash of changes.
    #   @changelog_hash = {
    #     '1.0.0' => {
    #       'Added' => "- Change 1\n- Change 2",
    #       'Fixed' => "- Bugfix"
    #     }
    #   }
    #
    # @return [Hash] Hash of version numbers, headers, and changesets.
    def parse
      @changelog.scan(@version_header_re) do |match|
        version_changes = Regexp.last_match.post_match
        scanner         = StringScanner.new(version_changes)
        scanner.scan_until(@version_header_re)
        version_changes           = parse_version_changes(scanner.pre_match || version_changes)
        @changelog_hash[match[0]] = version_changes
      end
      @changelog_hash
    end

    # Combine changes for multiple versions. The `since_version` is your `current` version.
    # This means that changes will start combining from the next version up.
    #
    # @param [String] since_version Version to start parsing from. Changes for this version won't be included.
    # @param [String] to_version Version to stop parsing at.
    def combine_changes(since_version, to_version = nil, print_header = true)
      parse if @changelog_hash.empty?

      combined_changes = {}
      filtered_changes = Marshal.load(Marshal.dump(@changelog_hash))
      if to_version
        filtered_changes.delete_if do |key, _|
          SemVersion.new(key) <= SemVersion.new(since_version) ||
            SemVersion.new(key) > SemVersion.new(to_version)
        end
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

      if print_header
        output = "## Changes since [#{since_version}]"
        output << " (and up to [#{to_version}])" if to_version
      else
        output = ''
      end

      combined_changes.each do |section, changes_list|
        output << "\n\n" unless output.empty?
        output << "### #{section}"
        output << "\n#{changes_list}"
      end

      output << "\n"
    end

    private

    # Parse a changeset for a specific version and return a hash of different kinds of changes.
    #
    # @param [String] changes Changeset for one version.
    #
    # @return [Hash] Hash with headers (`Added`, `Fixed`, etc) as keys and related changesets as values.
    def parse_version_changes(changes)
      changes_hash = {}
      changes.scan(@section_header_re) do |match|
        block_changes = Regexp.last_match.post_match
        scanner       = StringScanner.new(block_changes)
        scanner.scan_until(@section_header_re)
        changes_hash[match[0]] = (scanner.pre_match || block_changes).gsub(/(\A\n+|\n+\z)/, '')
      end
      changes_hash
    end
  end
end
