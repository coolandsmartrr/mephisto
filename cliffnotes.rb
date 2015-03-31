require 'nokogiri'
require 'open-uri'
require 'unindent'
require 'pry'

# Open the main page of Faust from Cliffnotes
START_URL = "http://www.cliffsnotes.com/literature/f/faust-parts-1-and-2/"
START_URI = URI.parse(START_URL)
doc = Nokogiri::HTML(open(START_URL))

# Make list of all URL to scrape
ALL_URL = doc.css('ul.toc-list > li a').map { |link| link['href']}
ALL_URL.uniq!
# puts ALL_URL.class # It's an array

# Method to obtain content
def obtain_content(doc)
  # Extract Cliffnotes content
  heading = doc.css('span.subheader-h3')
  content = doc.css('div#litnote-content')

  # Remove ad script
  doc.css('div#innerlayout_0_contentbody_0_separator').each do |node|
    node.remove
  end
  return heading.text.unindent, content.text.unindent
end

ALL_URL.each do |directory|
  uri = START_URI
  puts "#{uri.scheme}://#{uri.host}#{directory}"
  doc = Nokogiri::HTML(open "#{uri.scheme}://#{uri.host}#{directory}")
  puts obtain_content(doc)
end