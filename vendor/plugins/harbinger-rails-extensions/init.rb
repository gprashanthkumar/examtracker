# Include hook code here
ActionView::Base.send(:include, HarbingerRailsExtensions::Helpers)
ActionView::Base.send(:include, HarbingerRailsExtensions::ControllerMethods)
ActionController::Base.send(:include, HarbingerRailsExtensions::ControllerMethods)
