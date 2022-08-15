require 'open-uri'
require 'json'

class GamesController < ApplicationController
  VOWELS = %w(A E I O U Y)

  def new
    @grid = Array.new(5) { VOWELS.sample }
    @grid += Array.new(5) { (('A'..'Z').to_a - VOWELS).sample }
    @grid.shuffle!
  end

  def score
    @grid = params[:grid].split
    @word = (params[:word] || "").upcase
    @included = included?(@word, @grid)
    @english_word = english_word?(@word)
  end

  private

  def included?(word, grid)
    word.chars.all? { |letter| word.count(letter) <= grid.count(letter) }
  end

  def english_word?(word)
    response = URI.open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    json['found']
  end
end
