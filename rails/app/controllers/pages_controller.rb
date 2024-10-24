class PagesController < ApplicationController
  def home
    @selected = 'home'
  end

  def about
    @selected = 'about'
  end

  def contact
    @selected = 'contact'
  end
end