require 'nokogiri'
require 'open-uri'
require 'base64' # Ajout de la bibliothèque base64
require_relative '../config/environment'

# Méthode pour récupérer les informations de chaque livre sur une page
def scrape_page(url)
  puts "Scraping page #{url}..."
  html = URI.open(url)
  doc = Nokogiri::HTML(html)

  books = []

  # Récupération des titres, des dates et des images des couvertures
  doc.css('[data-testid="product-title"]').each_with_index do |title_node, index|
    title = title_node.text.strip
    year = doc.css('[data-testid="date-release"]')[index].text.strip
    cover_src = doc.css('[data-testid="poster-img"]')[index]['src']

    # Vérifier si l'URL de la couverture est une URL valide ou une URL encodée en base64
    if valid_image_url?(cover_src)
      cover_url = cover_src
    else
      # Décode l'URL encodée en base64
      decoded_cover_data = Base64.decode64(cover_src.split(',')[1])
      # Crée une URL temporaire pour l'image encodée en base64
      temp_cover_file = Tempfile.new(['cover', '.jpg'])
      temp_cover_file.binmode
      temp_cover_file.write(decoded_cover_data)
      cover_url = temp_cover_file.path
    end

    books << { title: title, year: year, cover_url: cover_url }
  end

  books
end

# Méthode pour vérifier si une URL est une URL d'image valide
def valid_image_url?(url)
  url.start_with?('http', 'https') && url.include?('.')
end

# Méthode pour scraper toutes les pages et rassembler les informations
def scrape_all_pages(base_url, total_pages)
  all_books = []

  total_pages.times do |page_number|
    page_url = "#{base_url}?page=#{page_number + 1}"
    all_books += scrape_page(page_url)
  end

  all_books
end

# URL de la première page
base_url = 'https://www.senscritique.com/liste/agatha_christie_par_ordre_chronologique/2971899'

# Nombre total de pages
total_pages = 3

# Scraper toutes les pages
all_books = scrape_all_pages(base_url, total_pages)

# Afficher les résultats
all_books.each do |book|
  puts "Titre : #{book[:title]}"
  puts "Date de sortie : #{book[:year]}"
  puts "URL de la couverture : #{book[:cover_url]}"
  puts "-----------------------------"
end

# Créer les livres dans la base de données
def create_books(book_data)
  book_data.each do |book|
    new_book = Book.new(
      title: book[:title],
      year: book[:year],
      cover_url: book[:cover_url]
    )

    if new_book.save
      puts "Livre sauvegardé : #{new_book.title}"
    else
      puts "Erreur lors de la sauvegarde du livre : #{new_book.errors.full_messages.join(', ')}"
    end
  end
end

# Sauvegarder les livres dans la base de données
create_books(all_books)
