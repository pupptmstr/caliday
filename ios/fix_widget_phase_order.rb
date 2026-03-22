#!/opt/homebrew/opt/ruby/bin/ruby
COCOAPODS_GEMS = '/opt/homebrew/Cellar/cocoapods/1.16.2_2/libexec/gems'
Dir.glob("#{COCOAPODS_GEMS}/*/lib").each { |p| $LOAD_PATH.unshift p }

require 'xcodeproj'

project = Xcodeproj::Project.open('ios/Runner.xcodeproj')
runner = project.targets.find { |t| t.name == 'Runner' }
abort "❌ Runner not found" unless runner

phases = runner.build_phases

puts "Current phase order:"
phases.each_with_index { |p, i| puts "  #{i}: #{p.class.name.split('::').last} — #{p.respond_to?(:name) ? p.name : ''}" }

embed_phase = phases.find do |p|
  p.is_a?(Xcodeproj::Project::Object::PBXCopyFilesBuildPhase) &&
    p.name&.include?('Extension')
end
abort "❌ Embed Foundation Extensions phase not found" unless embed_phase

# Find first shell script phase (CocoaPods "[CP] Check Pods Manifest.lock" or similar)
first_script_idx = phases.index do |p|
  p.is_a?(Xcodeproj::Project::Object::PBXShellScriptBuildPhase)
end
abort "❌ No script phases found" unless first_script_idx

current_idx = phases.index(embed_phase)
puts "\nEmbed phase is at index #{current_idx}, first script phase at #{first_script_idx}"

if current_idx > first_script_idx
  phases.delete_at(current_idx)
  # Insert before first script phase (index shifts by -1 after delete)
  insert_at = first_script_idx
  phases.insert(insert_at, embed_phase)
  puts "✅ Moved embed phase to index #{insert_at} (before script phases)"
else
  puts "✅ Embed phase already before script phases — no change needed"
end

project.save
puts "Saved."