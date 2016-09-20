require 'mechanize'
require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'vcr_cassettes'
  c.allow_http_connections_when_no_cassette = true
  c.hook_into :webmock
end

def get_vcr_page(name, url)
  VCR.use_cassette(name) do
    a = Mechanize.new
    a.get(url)
  end
end

def url_from_attributes(base_url, path, **attributes)
  url = base_url + path + "?"
  attributes.each do |attribute, value|
    url << "&" unless url[-1] == "?"
    url << attribute.to_s + "=" + value.to_s
  end
  url
end
