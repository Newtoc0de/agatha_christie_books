json.extract! book, :id, :title, :year, :read, :cover_url, :created_at, :updated_at
json.url book_url(book, format: :json)
