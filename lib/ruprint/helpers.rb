module Ruprint #:nodoc:
  module Helpers
    
    include Builders

    # The main helper for generating a grid
    def grid(&block)
      builder = GridBuilder.new(self)
      yield builder
      builder.render
    end

    # Adds the appropriate stylesheet link tags to your layout. One option:
    #  - css_dir (defaults to /stylesheets) to designate where to load the stylesheets from.
    def blueprint_link_tags(options = {})
      options[:css_dir] ||= "/stylesheets"

      out  = stylesheet_link_tag("#{options[:css_dir]}/screen", :media => "screen, projection")
      out += stylesheet_link_tag("#{options[:css_dir]}/print", :media => "print")
      out += stylesheet_link_tag("#{options[:css_dir]}/application")
      out += "<!--[if IE]>#{stylesheet_link_tag("#{options[:css_dir]}/ie", :media => "screen, projection")}<![endif]-->"
      out
    end

  end
end
