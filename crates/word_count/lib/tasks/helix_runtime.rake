require 'helix_runtime/build_task'

HelixRuntime::BuildTask.new("word_count")

task :default => :build
