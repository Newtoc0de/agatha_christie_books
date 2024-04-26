# app/helpers/book_helper.rb
module BookHelper
  def cover_valid?(cover_url)
    begin
      response = Net::HTTP.get_response(URI.parse(cover_url))
      return response.is_a?(Net::HTTPSuccess)
    rescue
      return false
    end
  end
end
