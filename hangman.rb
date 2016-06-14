require "yaml"

class Player

	attr_reader :name

	def initialize(name)
		@name = name
	end
end

class Hangman
	

	def initialize(name)
		@name = Player.new(name)
		@turn_number = 0
		@turns_left = 6
		@gallow = Gallow.new(@turn_number)
		
		#chooses random word from file. Use #slice to get rid of /r and /n at end of array
		@word_to_be_guessed = ""
		@blank_spaces = ""
		@current_guess = ""
		@incorrectly_guessed_letters = []
		@correctly_guessed_letters = []
				
		introduction_to_game
	end

	def introduction_to_game
		puts "\n\nWelcome to hangman, " + @name.name + " Please type New to start a new game..."
		puts "\nOr type load to load a game"

		user_letter
	end

	def user_letter
		@current_guess = gets.downcase.chomp

		if @current_guess == "new"
			ensure_correct_word_length
		elsif @current_guess == "save"
			save_game
		elsif @current_guess == "load"
			load_game.create_blank_spaces
		elsif @correctly_guessed_letters.include?(@current_guess.downcase) || @incorrectly_guessed_letters.include?(@current_guess.downcase)
			already_guessed_letter(@current_guess)
		else
			validate_input(@current_guess.downcase)
		end
	end

	def ensure_correct_word_length
		unless @word_to_be_guessed.length > 5 && @word_to_be_guessed.length < 12
			@word_to_be_guessed = File.readlines("hangman_word_choices.txt").sample.downcase.split("").slice(0..-3)
			ensure_correct_word_length
		end

		create_blank_spaces
	end

	def create_blank_spaces
		@blank_spaces = ["_ "] * @word_to_be_guessed.length
		puts @gallow.gallow_to_draw_on_turn(@turn_number)
		print @blank_spaces.join
		puts "\n\nPlease select a letter"

		user_letter
	end


	def validate_input(letter)
		valid_input = ("a".."z").to_a

		if valid_input.include?(@current_guess.downcase)
			check_for_user_letter_in_word(@current_guess.downcase)
		else
			reenter_input(letter)
		end
	end

	def already_guessed_letter(letter)
		puts "\nYou have already guessed #{letter}. Please choose another letter"
		puts @gallow.gallow_to_draw_on_turn(@turn_number)
		print "\n#{@blank_spaces.join(" ")}"
		puts "\n\nIncorrect Letters:"
		puts @incorrectly_guessed_letters.join(", ")

		user_letter
	end

	def reenter_input(letter)
		puts "\nSorry, #{letter} is not a valid input. Please choose a letter from A-Z"
		puts @gallow.gallow_to_draw_on_turn(@turn_number)
		print "\n#{@blank_spaces.join(" ")}"
		puts "\n\nIncorrect Letters:"
		puts @incorrectly_guessed_letters.join(", ")

		user_letter
	end

	def check_for_user_letter_in_word(letter)
		if @word_to_be_guessed.include?(@current_guess.downcase)
			@correctly_guessed_letters << @current_guess.downcase
			replace_blank_with_correct_letter(@current_guess.downcase)
		else
			incorrect_guess
		end
	end

	def replace_blank_with_correct_letter(letter)
		@word_to_be_guessed.each_with_index do |word_letter, index|
			if @current_guess.downcase == word_letter
				@blank_spaces[index] = @current_guess
			end
		end

		puts @gallow.gallow_to_draw_on_turn(@turn_number)
		print "\n#{@blank_spaces.join(" ")}"
		win_game
	end

	def incorrect_guess
		@incorrectly_guessed_letters << @current_guess.downcase
		@turns_left -= 1
		@turn_number += 1

		if @turns_left == 0
			puts @gallow.gallow_to_draw_on_turn(@turn_number)
			puts "\n\nSorry you are all out of guesses. Would you like to play again? (Y / N)"
			play_again
		else
			puts @gallow.gallow_to_draw_on_turn(@turn_number)
			print "\n#{@blank_spaces.join(" ")}"
			guess_again
		end
	end

	def guess_again
		puts "\n\nIncorrect Letters:"
		puts @incorrectly_guessed_letters.join(", ")
		puts "\nTo save your game, please type Save"

		puts "\n\nPlease guess another letter"
		user_letter
	end

	def win_game
		if @blank_spaces.all? { |space| ("a".."z").to_a.include?(space) }
			puts "\nYou Win!"
			puts "\nWould you like to play again? (Y / N)"

			play_again
		else 
			guess_again
		end
	end

	def play_again
		new_game = gets.chomp

		if new_game.downcase == "y"
			Hangman.new(@name.name)
		elsif new_game.downcase == "n"
			exit
		else
			puts "Please enter Y or N"
			play_again
		end
	end

	def save_game	
  	File.open('Saved_game.yaml', 'w') do |file|
    	file.puts YAML.dump(self)
  	end

		puts "\nYour game was saved successfully. Thank you!\n"
		exit
	end

	def load_game
		#content = File.open('Saved_game.yaml', 'r') { |file| file.read }
  	load_data = YAML::load(File.open("Saved_game.yaml"))

 		load_data.welcome_back
	end

	def welcome_back
		puts @gallow.gallow_to_draw_on_turn(@turn_number)
		print "\n#{@blank_spaces.join(" ")}"
		puts "\n\nIncorrect Letters:"
		puts @incorrectly_guessed_letters.join(", ")

		user_letter
	end
end


class Gallow < Hangman

	def initialize(turn)
		gallow_to_draw_on_turn(@turn)
	end

	def gallow_to_draw_on_turn(num)
		number = num
		case number.to_s
		when "0"
			puts %{_________
    |    |
    |         
    |        
    |        
    |
    |
  }
  	when "1"
  		puts %{_________
    |    |
    |    0
    |        
    |        
    |
    |
  }
  	when "2"
  		puts %{_________
    |    |
    |    0
    |    |
    |        
    |
    |
	}
		when "3"
			puts %{_________
    |    |
    |    0
    |   /
    |        
    |
    |
	}
		when "4"
			puts %{_________
    |    |
    |    0
    |   /|\\
    |        
    |
    |
	}
		when "5"
			puts %{_________
    |    |
    |    0
    |   /|\\
    |   /
    |
    |
	}
		when "6"
			puts %{_________
    |    |
    |    0
    |   /|\\
    |   / \\
    |
    |
	}
  		end
	end
end


Hangman.new("Harry")



 
