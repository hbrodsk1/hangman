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
		@gallow = Gallow.new(@turn_number)
		
		#chooses random word from file. Use #slice to get rid of /r and /n at end of array
		@word_to_be_guessed = File.readlines("hangman_word_choices.txt").sample.downcase.split("").slice(0..-3)
		@blank_spaces = ["_ "] * @word_to_be_guessed.size
		@current_guess = ""
		@incorrectly_guessed_letters = []
		@correctly_guessed_letters = []
		@turns_left = 6
		
		create_blank_spaces
	end

	def create_blank_spaces
		print @blank_spaces.join
		introduction_to_game
	end

	def introduction_to_game
		puts "\n\nWelcome to hangman, #{@name}. Please guess a letter..."
		print @word_to_be_guessed
		user_letter
	end

	def user_letter
		@current_guess = gets.chomp

		if @correctly_guessed_letters.include?(@current_guess.downcase) || @incorrectly_guessed_letters.include?(@current_guess.downcase)
			already_guessed_letter(@current_guess)
		else
			validate_input(@current_guess.downcase)
		end
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
		guess_again
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

		puts "\n\nPlease guess another letter"
		user_letter
	end

	def play_again
		new_game = gets.chomp

		if new_game.downcase == "y"
			Hangman.new(@name)
		elsif new_game.downcase == "n"
			exit
		else
			puts "Please enter Y or N"
			play_again
		end
	end
end

class Gallow < Hangman

	def initialize(turn)
		@turn = turn
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



 
