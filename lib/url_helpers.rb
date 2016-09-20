def url_from_attributes(base_url, path, **attributes)
  url = base_url + path + "?"
  attributes.each do |attribute, value|
    url << "&" unless url[-1] == "?"
    url << attribute.to_s + "=" + value.to_s
  end
  url
end
