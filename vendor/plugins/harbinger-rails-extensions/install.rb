require File.join(File.dirname(__FILE__), "plugin_utils")

plug = PluginUtils::Installer.new('harbinger-rails-extensions') do |plugin|
  plugin.install_file("lib/layouts/application.html.erb", "app/views/layouts", {
                        :overwrite => false,
                        :message => "FILE: Copying application.html.erb to app/views/layouts/application.html.erb..."
  })
  plugin.install_file("lib/stylesheets/harbinger.css", {
                        :overwrite => false,
                        :message => "FILE: Copying harbinger.css to public/stylesheets..."
                      })
end

plug.install!
