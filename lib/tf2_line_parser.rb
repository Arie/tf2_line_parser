require "ext/string"
require "tf2_line_parser/version"
require "tf2_line_parser/parser"
%w(event assist chat damage heal kill match_end point_capture round_start round_win round_stalemate console_say current_score unknown).each do |e|
  require "tf2_line_parser/events/#{e}"
end
require "tf2_line_parser/line"



module TF2LineParser
end
