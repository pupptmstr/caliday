#!/opt/homebrew/opt/ruby/bin/ruby
COCOAPODS_GEMS = '/opt/homebrew/Cellar/cocoapods/1.16.2_2/libexec/gems'
Dir.glob("#{COCOAPODS_GEMS}/*/lib").each { |p| $LOAD_PATH.unshift p }

require 'xcodeproj'

project = Xcodeproj::Project.open('ios/Runner.xcodeproj')

# Fix group path: ios/CaliDayWidget -> CaliDayWidget (relative to ios/)
group = project.main_group.find_subpath('CaliDayWidget')
abort "❌ CaliDayWidget group not found" unless group

if group.path&.start_with?('ios/')
  group.path = group.path.sub('ios/', '')
  puts "Fixed group path: #{group.path}"
end

# Fix all file references inside the group
group.files.each do |ref|
  if ref.path&.start_with?('ios/')
    ref.path = ref.path.sub('ios/', '')
    puts "Fixed file ref: #{ref.path}"
  end
end

project.save
puts "✅ Paths fixed"