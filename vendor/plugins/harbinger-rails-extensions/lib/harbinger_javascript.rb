module HarbingerRailsExtensions

  module ControllerMethods
  end

  module Helpers
    def harbingerjs_setup
      raw(setup_cometd_url + setup_relative_root_path)
    end

    def setup_cometd_url
      begin
        cometd_url = javax.naming.InitialContext.new.lookup("harbinger-config").getProperty("cometd-amqp.url")
      rescue NativeException => e
        cometd_url = ""
      end
      '<script language="javascript">
         var harbingerjsCometdURL = "' + cometd_url.to_s + '";
       </script>'
    end

    def setup_asic(xdr_location="harbingerjs/xdr")
      c1 = '<script type="text/javascript">' +
        "(function($) {" +
        "  if ($.harbingerjs == undefined) { $.harbingerjs = {}; $.harbingerjs.asic = {}};" +
        "  $.harbingerjs.asic.jsonp_fallback = !$.support.cors;" +
        "})(jQuery);" +
        '</script>'

      c2 = "" +
        "<!--[if gte IE 8]>" +
        javascript_include_tag(xdr_location) +
        content_tag(:script, "(function($) { $.harbingerjs.asic.jsonp_fallback = false; })(jQuery);", :type => "text/javascript") +
        '<![endif]-->'

      c1 + c2
    end

    def setup_relative_root_path()
      javascript_tag("var harbingerjsRelativeRoot = \"#{Rails.configuration.action_controller[:relative_url_root] || '/'}\";");
    end

  end

end
