require 'open-uri'
require 'json'

class GamesController < ApplicationController

  def new
    @grid = Array.new(10) { ("a".."z").to_a.sample }
  end

  def score
    @word = params[:word]
    @grid = params[:grid]

    @included = included?(@word, @grid)
    @valid_word = english_word?(@word)

    if @included && @valid_word
      @answer = "Congrats, you found a word - you arent completely retarded"
    elsif @included && !(@valid_word)
      @answer = "Jeez boy, that aint even an english word you dumb fuck"
    elsif @valid_word && !(@included)
     @answer = "Mate, you are supposed to chose from the given letters, fucking dumbass"
    end
  end

  def included?(word, grid)
    word.chars.all? { |letter| word.count(letter) <= grid.count(letter) }
  end

  def english_word?(word)
    response = open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    return json['found']
  end
end
