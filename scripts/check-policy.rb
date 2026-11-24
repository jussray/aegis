require 'yaml'
require 'pathname'

def validate_policy(root)
  policy = File.read(root.join('SECURITY.md'))
  cadence = policy[/cadence:\s*(daily|weekly|monthly)\b/i, 1]
  raise 'Missing declared cadence' unless cadence
  config = YAML.safe_load_file(root.join('.github/dependabot.yml'))
  owners = File.read(root.join('.github/CODEOWNERS'))
  raise 'No security owner' unless owners.lines.any? { |l| l.strip == '/.github/ @jussray' }
  raise 'Missing advisory source' unless policy.include?('advisory source: GitHub Advisories')
  updates = config.fetch('updates')
  raise 'No update entries' unless updates.is_a?(Array) && !updates.empty?
  updates.each do |entry|
    raise 'Cadence drift' unless entry.fetch('schedule').fetch('interval') == cadence
    raise 'Security reviewer missing' unless entry.fetch('reviewers').include?('jussray')
    raise 'Security label missing' unless entry.fetch('labels').include?('security')
  end
  Dir.glob(root.join('.github/workflows/*.yml')).each do |path|
    File.read(path).scan(/^\s*(?:-\s+)?uses:\s*([^\s#]+)/).flatten.each do |ref|
      next if ref.start_with?('./')
      raise "Unpinned action: #{ref}" unless ref.match?(/@[a-f0-9]{40}\z/)
    end
  end
  true
end

if $PROGRAM_NAME == __FILE__
  validate_policy(Pathname.new(__dir__).parent)
  puts 'Policy configuration checks passed; repository settings and advisory freshness remain separate.'
end
