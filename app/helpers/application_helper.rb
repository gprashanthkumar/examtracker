module ApplicationHelper
  def global_navigation_link(title,url_opts, matching_url_ops = {})
    matching_url_ops = url_opts if matching_url_ops == {}
    matches = matching_url_ops.keys.collect {|key| matching_url_ops[key].to_s == params[key].to_s ? true : false }
    matches.include?(false) ? active = "" : active = "active"
    content_tag(:li, link_to(title, url_opts, :name => title.downcase.gsub(" ","-").gsub("/","")), :class => active)
  end
  
  def javascriptHead(*files)
    content_for(:head_javascript) { javascript_include_tag(*files) }
  end
 
  def stylesheetHead(*files)
    content_for(:head_stylesheet) { stylesheet_link_tag(*files) }
  end

  def javascriptBody(*files)
    content_for(:body_javascript) { javascript_include_tag(*files) }
  end
 
  #def stylesheet(*files)
  #  content_for(:body_stylesheet) { stylesheet_link_tag(*files) }
  #end
  
end
