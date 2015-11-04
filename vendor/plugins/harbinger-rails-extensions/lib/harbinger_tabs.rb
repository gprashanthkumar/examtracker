module HarbingerRailsExtensions
  class TabBuilder
    attr_reader :helpers
    attr_accessor :options, :tab_heading

    #If a method called in a block is not found in the Table instance it is then passed to the view instance which has access to included helper methods
    def method_missing(method, *args, &block)
      helpers.send(method, *args, &block)
    end

    def initialize(active_tab_var, view_instance, opts={}, *args)
      @active_tab_var = active_tab_var
      @tabs = []
      @helpers = view_instance
      self.options = opts
      self.options[:continuation] = {} unless self.options[:continuation]
      params[active_tab_var] = self.options[:default] unless params[active_tab_var] or self.options[:continuation][active_tab_var]
      self.tab_heading = options[:heading]
    end

    def tab(name, *args, &block)
      (name == params[@active_tab_var] or name == options[:continuation][name]) ?  li_class = "active" : li_class = ""
      if block_given?
        @tabs << content_tag(:li, yield(self.options), :class => li_class)
      else
        self.tab_link_to(*([name] + args))
      end
    end

    def tab_link_to(*args)
      args[1] = {} unless args[1]
      args[1][:title] = args[0] unless args[1][:title]
      args[1].merge!(self.options[:continuation]) if self.options[:continuation]
      args[1].merge!(self.options[:url]) if self.options[:url]
      args[1].merge!({@active_tab_var => args[0]}) unless args[1][@active_tab_var]
      tab(args[0]) { helpers.link_to(args[1][:title],args[1]) }
    end

    def render
      extra_heading = (self.tab_heading.blank? ? "" : content_tag(:span, self.tab_heading, :class => "tab-heading"))
      content_tag(:div, content_tag(:ul, extra_heading + @tabs.join("\n"), :class => "tabs primary"), :class => "tabs")
    end
  end

  #Helper that instantiates the Tab Builder
  def harbinger_tab_builder(active_tab_var, options={}, *args, &block)
    tab_builder = HarbingerRailsExtentions::TabBuilder.new(active_tab_var, self, options, *args)
    yield tab_builder
    concat(tab_builder.render)
  end

end
