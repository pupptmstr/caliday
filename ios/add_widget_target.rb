#!/opt/homebrew/opt/ruby/bin/ruby
# Script to add CaliDayWidget Extension target to Runner.xcodeproj
# Run from project root: ruby ios/add_widget_target.rb

COCOAPODS_GEMS = '/opt/homebrew/Cellar/cocoapods/1.16.2_2/libexec/gems'
Dir.glob("#{COCOAPODS_GEMS}/*/lib").each { |p| $LOAD_PATH.unshift p }

require 'xcodeproj'

PROJECT_PATH    = 'ios/Runner.xcodeproj'
WIDGET_NAME     = 'CaliDayWidget'
BUNDLE_ID       = 'com.pupptmstr.caliday.CaliDayWidget'
DEPLOYMENT_TARGET = '14.0'

project = Xcodeproj::Project.open(PROJECT_PATH)

if project.targets.any? { |t| t.name == WIDGET_NAME }
  puts "⚠️  Target '#{WIDGET_NAME}' already exists — nothing to do."
  exit 0
end

puts "Creating target '#{WIDGET_NAME}'..."

# ── 1. New app extension target ──────────────────────────────────────────────
widget_target = project.new_target(
  :app_extension,
  WIDGET_NAME,
  :ios,
  DEPLOYMENT_TARGET
)

# ── 2. Build settings ─────────────────────────────────────────────────────────
widget_target.build_configurations.each do |config|
  s = config.build_settings
  s['PRODUCT_BUNDLE_IDENTIFIER']      = BUNDLE_ID
  s['SWIFT_VERSION']                  = '5.0'
  s['IPHONEOS_DEPLOYMENT_TARGET']     = DEPLOYMENT_TARGET
  s['TARGETED_DEVICE_FAMILY']         = '1,2'
  s['SKIP_INSTALL']                   = 'YES'
  s['CODE_SIGN_ENTITLEMENTS']         = "#{WIDGET_NAME}/#{WIDGET_NAME}.entitlements"
  # Use auto-generated Info.plist (Xcode 13+)
  s['GENERATE_INFOPLIST_FILE']        = 'YES'
  s['INFOPLIST_KEY_NSExtension_NSExtensionPointIdentifier'] = 'com.apple.widgetkit-extension'
  s['INFOPLIST_KEY_CFBundleDisplayName'] = 'CaliDay'
  # WidgetKit + SwiftUI auto-link via @import; no manual framework needed
  s['ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES'] = 'NO'
end

# ── 3. File group + sources ───────────────────────────────────────────────────
widget_group = project.main_group.find_subpath(WIDGET_NAME) ||
               project.main_group.new_group(WIDGET_NAME, "ios/#{WIDGET_NAME}")

swift_ref = widget_group.new_reference("#{WIDGET_NAME}.swift")
swift_ref.last_known_file_type = 'sourcecode.swift'
widget_target.source_build_phase.add_file_reference(swift_ref)

assets_ref = widget_group.new_reference('Assets.xcassets')
assets_ref.last_known_file_type = 'folder.assetcatalog'
widget_target.resources_build_phase.add_file_reference(assets_ref)

entitlements_ref = widget_group.new_reference("#{WIDGET_NAME}.entitlements")
entitlements_ref.last_known_file_type = 'text.plist.entitlements'
# entitlements are not added to build phases, just referenced in build settings

# ── 4. Embed extension in Runner ──────────────────────────────────────────────
runner = project.targets.find { |t| t.name == 'Runner' }
abort "❌  Runner target not found!" unless runner

# Add target dependency so Runner builds the widget first
runner.add_dependency(widget_target)

# Create "Embed Foundation Extensions" copy-files phase
embed_phase = runner.build_phases.find do |p|
  p.is_a?(Xcodeproj::Project::Object::PBXCopyFilesBuildPhase) &&
    p.name == 'Embed Foundation Extensions'
end

unless embed_phase
  embed_phase = project.new(Xcodeproj::Project::Object::PBXCopyFilesBuildPhase)
  embed_phase.name            = 'Embed Foundation Extensions'
  embed_phase.symbol_dst_subfolder_spec = :plug_ins
  runner.build_phases << embed_phase
end

embed_file = embed_phase.add_file_reference(widget_target.product_reference)
embed_file.settings = { 'ATTRIBUTES' => ['RemoveHeadersOnCopy'] }

# ── 5. Save ───────────────────────────────────────────────────────────────────
project.save
puts "✅  Done! CaliDayWidget target added to #{PROJECT_PATH}"
puts ""
puts "Next steps in Xcode:"
puts "  1. Runner target → Signing & Capabilities → App Groups → group.com.pupptmstr.caliday"
puts "  2. CaliDayWidget target → Signing & Capabilities → App Groups → group.com.pupptmstr.caliday"
puts "  3. Build & run — then long-press home screen → + → search CaliDay"