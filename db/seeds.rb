# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Use nokogiri to scrape for the addresses for massachusetts
require 'nokogiri'
require 'open-uri'

doc = Nokogiri::HTML(open('http://www.google.com/search?q=Bay State Medical Center'))  # Do funky things with it using Nokogiri::XML::Node methods...

  ####
  # Search for nodes by css
  doc.css('h3.r a.l').each do |link|
    puts link.content
  end

  ####
  # Search for nodes by xpath
  doc.xpath('//h3/a[@class="l"]').each do |link|
    puts link.content
  end

  ####
  # Or mix and match.
  doc.search('h3.r a.l', '//h3/a[@class="l"]').each do |link|
    puts link.content
  end
