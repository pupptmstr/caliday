#!/opt/homebrew/opt/ruby/bin/ruby
COCOAPODS_GEMS = '/opt/homebrew/Cellar/cocoapods/1.16.2_2/libexec/gems'
Dir.glob("#{COCOAPODS_GEMS}/*/lib").each { |p| $LOAD_PATH.unshift p }

require 'xcodeproj'

project = Xcodeproj::Project.open('ios/Runner.xcodeproj')

widget = project.targets.find { |t| t.name == 'CaliDayWidget' }
abort "❌ CaliDayWidget target not found" unless widget

widget.build_configurations.each do |config|
  config.build_settings['PRODUCT_NAME'] = 'CaliDayWidget'
  config.build_settings['PRODUCT_BUNDLE_IDENTIFIER'] = 'com.pupptmstr.caliday.CaliDayWidget'
end

project.save
puts "✅ PRODUCT_NAME fixed for CaliDayWidget"