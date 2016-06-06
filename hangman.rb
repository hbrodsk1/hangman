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
		@word_to_be_guessed = File.readlines("hangman_word_choices.txt").sample
		@blank_spaces = "_ " * @word_to_be_guessed.length
		@previously_guessed_letters = []
		
		create_blank_spaces
	end

	def create_blank_spaces
		puts @blank_spaces
		introduction_to_game
	end

	def introduction_to_game
		puts "\n\nWelcome to hangman, #{@name}. Please guess a letter..."
		user_letter
	end

	def user_letter
		user_input = gets.chomp

		validate_input(user_input.downcase)
	end

	def validate_input(str)
		valid_input = ("a".."z").to_a

		if valid_input.include?(str)
			next_method
		else
			reenter_input(str)
		end
	end

	def reenter_input(str)
		puts "\nSorry, #{str} is not a valid input. Please choose a letter from A-Z"

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



 
