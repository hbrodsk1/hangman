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



 
