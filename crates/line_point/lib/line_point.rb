require "helix_runtime"

begin
  require "line_point/native"
rescue LoadError
  warn "Unable to load line_point/native. Please run `rake build`"
end
