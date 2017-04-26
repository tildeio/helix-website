require "helix_runtime"

begin
  require "inline_css/native"
rescue LoadError
  warn "Unable to load inline_css/native. Please run `rake build`"
end
