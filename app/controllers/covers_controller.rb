class CoversController < ApplicationController
  def show
    cover_path = Rails.root.join('app', 'assets','images', 'covers', params[:filename])


    puts cover_path
    # Envoie le fichier image en réponse
    send_file cover_path, type: 'image/jpeg', disposition: 'inline'
  end
end
