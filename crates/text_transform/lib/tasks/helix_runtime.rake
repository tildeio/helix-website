require 'helix_runtime/build_task'

HelixRuntime::BuildTask.new("text_transform")

task :default => :build
