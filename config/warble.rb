Warbler::Config.new do |config|
  config.jar_name = "vanilla-app"
  config.webxml.jruby.min.runtimes = 2
  config.webxml.jruby.max.runtimes = 10
  config.java_libs += FileList["sdk/*standalone.jar"]
end
