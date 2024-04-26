class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home ]
  include BookHelper

  def home
    @books = Book.all.order(:title)
    @books = filter_books(params[:character]) if params[:character].present?
  end

  private

  def filter_books(character)
    Book.where('title LIKE ?', "#{character}%").order(:title)
  end
end
