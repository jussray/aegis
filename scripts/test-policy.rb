require 'tmpdir'
require 'fileutils'
require_relative 'check-policy'

Dir.mktmpdir do |dir|
  root = Pathname.new(dir)
  source = Pathname.new(__dir__).parent
  FileUtils.cp(source.join('SECURITY.md'), root)
  FileUtils.cp_r(source.join('.github'), root)
  raise 'Baseline invalid' unless validate_policy(root)
  file = root.join('.github/dependabot.yml')
  original = File.read(file)
  [
    ['cadence drift', original.sub('interval: weekly', 'interval: monthly')],
    ['missing reviewer', original.sub('["jussray"]', '["other"]')],
    ['missing security label', original.sub('"security", ', '')]
  ].each do |name, mutation|
    raise "Mutation did not change file: #{name}" if original == mutation
    File.write(file, mutation)
    failed = false
    begin
      validate_policy(root)
    rescue RuntimeError
      failed = true
    end
    raise "False green: #{name}" unless failed
  end
  File.write(file, original)
  File.write(root.join('.github/workflows/unpinned.yml'), "steps:\n  - uses: actions/checkout@v4\n")
  failed = false
  begin
    validate_policy(root)
  rescue RuntimeError
    failed = true
  end
  raise 'False green: unpinned action' unless failed
end
puts 'Four negative control tests passed.'
