module HarbingerRailsExtensions
  module Helpers
    def format_report(text)
      if text.nil?
        return ""
      end

      ["indication","comparison","technique"].each do |kword|
        text.gsub!(/#{kword}\:/i) {|match| content_tag(:span, match, :class => "report-heading") }
      end

      if text.match(/(impression\:\:)(.*)(end of impression[\:\.]*)/im)
        text.gsub!(/(impression\:)(.*)(end of impression[\:\.]*)/im) {|match| content_tag(:p, content_tag(:span, $1, :class => "report-heading") + $2 + content_tag(:span, $3, :class => "report-heading"), :class => "report-impression") }
      else
        text.gsub!(/(impression\:|findings\:|findings\/\s+impression)(.*)/im) {|match| content_tag(:p, content_tag(:span, $1, :class => "report-heading") + $2, :class => "report-impression") }
      end
      text = nl2br(text)

      text
    end
  end
end
