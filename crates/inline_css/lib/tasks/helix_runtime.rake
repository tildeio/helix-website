require 'helix_runtime/build_task'

HelixRuntime::BuildTask.new("inline_css")

task :default => :build
