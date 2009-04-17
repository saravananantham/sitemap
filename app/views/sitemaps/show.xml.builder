
xml.instruct! :"xml-stylesheet", :type=>"text/xsl", :href=>"sitemap.xsl"

xml.urlset "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance", "xsi:schemaLocation" => "http://www.sitemaps.org/schemas/sitemap/0.9 http://www.sitemaps.org/schemas/sitemap/0.9/siteindex.xsd", "xmlns" => "http://www.sitemaps.org/schemas/sitemap/0.9" do
 xml.url do
    xml.loc         url_for(root_url)
    xml.lastmod     w3c_date(Time.now)
    xml.changefreq  "always"
    xml.priority    1.0
  end

  xml.url do
    xml.loc         url_for(sitemap_url)
    xml.lastmod     w3c_date(Time.now)
    xml.changefreq  "always"
    xml.priority    1.0
  end  
  
  @static_links.each do |static_link|
    xml.url do
      xml.loc         url_for("http://#{request.host_with_port}#{send(static_link.url.to_sym)}")
      xml.lastmod     w3c_date(Time.now)
      xml.changefreq  static_link.frequency
      xml.priority    static_link.priority
    end 
  end

  
@widgets.each do |widget|
#  xml.url do
#    xml.loc         url_for(send(widget.index_named_route.to_sym))
#    xml.lastmod     w3c_date(Time.now)
#    xml.changefreq  widget.frequency_index
#    xml.priority    widget.priority
#  end
#  
  widget.find_children.each do |child|
      xml.url do
        dynamic_url = widget.dynamic_path.split(",")        
        if dynamic_url.length == 1
          xml.loc         polymorphic_url([child,dynamic_url.first])
        elsif dynamic_url.length == 2
          xml.loc         polymorphic_url([child.send(dynamic_url.first),child,dynamic_url.last])
        elsif dynamic_url.length == 3
          xml.loc         polymorphic_url([(child.send(dynamic_url[1])).send(dynamic_url[0]),child.send(dynamic_url[1]),child])
        else
          xml.loc         polymorphic_url(child)          
        end
        xml.lastmod     w3c_date(child.updated_at || Time.now) if child.respond_to?('updated_at')
        xml.lastmod     w3c_date(Time.now) unless child.respond_to?('updated_at')
        xml.changefreq  widget.frequency_show
        xml.priority    widget.priority
    end
    
  end
end

end