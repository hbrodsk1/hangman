class Player

	attr_reader :name

	def initialize(name)
		@name = name
	end
end

class Hangman

	def initialize(name)
		@name = Player.new(name)
		@gallow = Gallow.new(0)
		
		#chooses random word from file. Use #slice to get rid of /r and /n at end of array
		@word_to_be_guessed = File.readlines("hangman_word_choices.txt").sample.downcase.split("").slice(0..-3)
		@blank_spaces = "_ " * @word_to_be_guessed.size
		@current_guess = ""
		@incorrectly_guessed_letters = []
		
		create_blank_spaces
	end

	def create_blank_spaces
		puts @blank_spaces
		introduction_to_game
	end

	def introduction_to_game
		puts "\n\nWelcome to hangman, #{@name}. Please guess a letter..."
		print @word_to_be_guessed
		user_letter
	end

	def user_letter
		@current_guess = gets.chomp

		validate_input(@current_guess.downcase)
	end

	def validate_input(letter)
		valid_input = ("a".."z").to_a

		if valid_input.include?(@current_guess.downcase)
			check_for_user_letter_in_word(@current_guess.downcase)
		else
			reenter_input(letter)
		end
	end

	def reenter_input(letter)
		puts "\nSorry, #{letter} is not a valid input. Please choose a letter from A-Z"

		user_letter
	end

	def check_for_user_letter_in_word(letter)
		if @word_to_be_guessed.include?(@current_guess.downcase)
			replace_blank_with_correct_letter(@current_guess.downcase)
		else
			@incorrectly_guessed_letters << @current_guess.downcase
			puts @incorrectly_guessed_letters.join(", ")

			user_letter
		end
	end

	def replace_blank_with_correct_letter(letter)
		@blank_spaces = @word_to_be_guessed
		@blank_spaces.each do |word_letter|
			if @current_guess.downcase == word_letter
				print @current_guess.downcase + " "
			else
				print "_ "
			end
		end
		
		user_letter
	end
end

class Gallow < Hangman

	def initialize(turn)
		@turn = turn
		gallow_to_draw_on_turn(turn)
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



 
