require "tf2_line_parser/version"
require "tf2_line_parser/parser"
require "tf2_line_parser/line"

%w(assist chat damage heal kill match_end point_capture round_start round_win stalemate console_say).each do |e|
  require "tf2_line_parser/events/#{e}"
end


module TF2LineParser
end
