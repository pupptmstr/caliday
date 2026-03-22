#!/opt/homebrew/opt/ruby/bin/ruby
COCOAPODS_GEMS = '/opt/homebrew/Cellar/cocoapods/1.16.2_2/libexec/gems'
Dir.glob("#{COCOAPODS_GEMS}/*/lib").each { |p| $LOAD_PATH.unshift p }

require 'xcodeproj'

project = Xcodeproj::Project.open('ios/Runner.xcodeproj')
widget = project.targets.find { |t| t.name == 'CaliDayWidget' }
abort "❌ CaliDayWidget not found" unless widget

widget.build_configurations.each do |config|
  s = config.build_settings
  # Switch from auto-generated to explicit Info.plist
  s.delete('GENERATE_INFOPLIST_FILE')
  s.delete('INFOPLIST_KEY_NSExtension_NSExtensionPointIdentifier')
  s.delete('INFOPLIST_KEY_CFBundleDisplayName')
  s['INFOPLIST_FILE'] = 'CaliDayWidget/Info.plist'
  puts "#{config.name}: INFOPLIST_FILE = CaliDayWidget/Info.plist"
end

# Also add Info.plist to the file group if not already there
group = project.main_group.find_subpath('CaliDayWidget')
if group && group.files.none? { |f| f.path == 'Info.plist' }
  plist_ref = group.new_reference('Info.plist')
  plist_ref.last_known_file_type = 'text.plist.xml'
  puts "Added Info.plist to CaliDayWidget group"
end

project.save
puts "✅ Done"