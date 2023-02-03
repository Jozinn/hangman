class Game
    def intialize(player_class, path, lifes)
        @player = player_class.new
        @lifes = lifes
        @words = File.open(path, 'r').readlines
        load_save()
    end
    
    attr_reader :words, :player

    def load_save
        puts 'press l to load save or press any other key to continue'
        key = gets.chomp
        return if (key != 'l')
        if (!File.exists?('save.txt'))
            puts 'You don\'t have any game saved yet'
            return
        end
        file = File.open('save.txt', 'r')
        lines = file.readlines
        self.hidden_word = lines[0]
        self.lifes = lines[1]
        file.close
    end

    def save_game
        file = File.open('save.txt', 'w')
        puts hidden_word
        puts lifes
        file.close
    end
        

    def draw_word
        word_index = rand(words.length)
        @word = words[word_index]
    end

    attr_reader :word

    def hide_word
        @hidden_word = word.map {|char| char == ' ' ? ' ' : '_'}
        return hidden_word
    end

    attr_accessor :hidden_word, :lifes

    def check_guess(guess)
        if (!word.exists?(guess))
            self.lifes -= 1
            return
        end
        word.each_with_index do |char, i|
            if (char == guess)
                self.hidden_word[i] = char
            end
        end
    end

    def print_game_state
        puts hidden_word
        lifes.time {print '*'}
    end

    def check_win_or_loose
        ifwin = hidden_word.select {|char| char == '_'}
        return 'win' if (ifwin.length == 0)
        return 'loose' if (lifes == 0)
    end

    def game
        puts 'Hangman'
        puts 'Guess the secret word and win'
        draw_word()
        hide_word()
        loop do
            print_game_state()
            puts 'run save command to save the game'
            players_guess = player.move
            if (player_guess == 'save')
                save_game()
                break
            end
            check_guess(players_guess)
            win_or_loose = check_win_or_loose()
            if (win_or_loose)
                puts "You #{win_or_loose}"
                break
            end
        end
        puts 'press g to start again'
    end
end

class Player
    def move
        puts 'Your guess:'
        guess = gets.chomp.downcase
        return guess
    end
end

game = Game.new(Player, 'words.txt', 15)
game.game

loop do
    key = gets.chomp
    if(key == 'g')
        game.game
    end
end
