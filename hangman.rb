require 'sinatra'
require 'sinatra/reloader' if development?
require "yaml"

use Rack::Session::Pool, :expire_after => 2592000

get "/" do
	redirect to session[:game].nil? ? "/reset" : "/play"
end

get "/reset" do
	session[:game] = new_game
	redirect to('/play')
end

get '/play' do
	redirect to "/reset" unless session[:game]
	
	session[:guess] = params['guess']
	session[:game].guess_letter(session[:guess])
	word = session[:game].word
	blank_spaces = session[:game].blank_spaces
	turns_left = session[:game].guesses
	incorrect_guesses = session[:game].incorrect_guesses
	redirect to "/win" if session[:game].win?
	redirect to "/game_over" if session[:game].game_over?
	erb :index, :locals => { word: word, blank_spaces: blank_spaces, turns_left: turns_left, incorrect_guesses: incorrect_guesses }
end

get '/win' do
	blank_spaces = session[:game].blank_spaces
	session[:new_game] = params['new_game']
	redirect to "/reset" unless session[:new_game].nil?
	erb :win, :locals => { blank_spaces: blank_spaces }
end

get '/game_over' do
	saved_word = session[:game].saved_word
	session[:new_game] = params['new_game']
	redirect to "/reset" unless session[:new_game].nil?
	erb :game_over, :locals => { saved_word: saved_word }
end

def new_game
	Hangman.new
end

class Hangman
	attr_reader :word, :saved_word, :guesses, :blank_spaces, :guessed_letters, :incorrect_guesses

	def initialize(guesses = 6, min = 5, max = 12)
		@word = Dictionary.new.dictionary
		@saved_word = @word.join
		@guesses = guesses
		@blank_spaces = ["_ "].join * @word.length
		@guessed_letters = []
		@incorrect_guesses = []
	end

	def guess_letter(guess)
		if guess && guess.length == 1 && guess.between?('a','z') && !@guessed_letters.include?(guess)
			process_guess(guess)
			@guessed_letters << guess
		else

		end
	end

	def process_guess(guess)
		unless @word.include?(guess)
			@incorrect_guesses << guess
			@guesses -= 1
		end

		while @word.include?(guess)
			@blank_spaces[@word.index(guess) * 2] = guess
			@word[@word.index(guess)] = ""
		end
	end

	def game_over?
		game_over = false
		game_over = true if(!@blank_spaces.include?("_") || @guesses <= 0)
		game_over
	end

	def win?
		win = false
		win = true if (game_over? && @guesses > 0)
		win
	end

end

class Dictionary
	attr_reader :dictionary

	def initialize
		@dictionary = ""
		choose_word
	end

	def choose_word(min = 5, max = 12)
		unless @dictionary.length.between?(min, max)
			@dictionary = File.readlines("hangman_word_choices.txt").sample.downcase.split("").slice(0..-3)
			choose_word
		end

		@dictionary
	end
end