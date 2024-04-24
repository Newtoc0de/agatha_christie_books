require 'nokogiri'
require 'open-uri'
require_relative '../config/environment'


# URL de la page Goodreads pour les livres d'Agatha Christie
url = 'https://www.goodreads.com/author/list/123715.Agatha_Christie'

# Parsing de la page HTML
html = URI.open(url)
doc = Nokogiri::HTML(html)

# Récupération des titres et des URLs des couvertures des livres
books = []
doc.css('.bookTitle').each do |book_title|
  title = book_title.text.strip
  cover_url = book_title.parent.parent.css('.bookCover').css('img').attribute('src').value
  books << { title: title, cover_url: cover_url }
end

#Enregistrement dans la BD
books.each do |book_data|
  Book.create(title: book_data[:title], cover_url: book_data[:cover_url])
end


# Affichage des résultats
books.each do |book|
  puts "Titre : #{book[:title]}"
  puts "URL de la couverture : #{book[:cover_url]}"
  puts "-----------------------------"
end
