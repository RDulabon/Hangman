require "json" 
class Game 
  load "hangman_board.rb" 
  include Board 

  def initialize(word=File.open("5desk.txt"))
    @word = word
    @hidden_word
    @guess 
    @blank_word 
    @miss = 0 
    @guessed = [*("a".."z")].join(" ")
    @choice 
  end 

  def choose_word
    valid_dictionary = @word.select { |line| line if line.chomp.length.between?(5, 12) && line[0] != line[0].upcase }  
    @hidden_word = valid_dictionary[rand(0..valid_dictionary.length-1)].chomp  
  end

  def welcome
    puts " Welcome to Hangman!"
    puts " Would you like to start a New Game (Enter '1') or load a Saved Game (Enter '2')?"
    @choice = gets.chomp.to_i 
    if @choice == 1
      puts " Great! Let's start!"
    elsif @choice == 2
      load
    else 
      puts " That is an invalid entry. Please try again."
      welcome 
    end 
  end

  def display_blank 
    @blank_word = "_ " * @hidden_word.length 
    puts "The secret word is: #{@blank_word}"
  end

  def guess
    puts " You can save your game and quit at any time by typing 'save'." 
    puts " If you'd like to continue, enter your guess:"
    @guess = gets.chomp.downcase 
    if @guess.length > 1 && @guess != "save"
      puts " That is an invalid entry. Please try again."
      guess 
    elsif @guess == "save"
      save_game
      exit 
    end 
  end

  def guessed_letters
    @guessed.delete!(@guess) 
    puts " Letters to guess: #{@guessed}" 
  end

  def check_letter
    @hidden_word.include? @guess 
  end 

  def check_solution
    @guess == @hidden_word
  end 

  def update_blanks
    @blank_word.split(" ").each_index { |x| @blank_word[x*2] = @guess if @hidden_word[x] == @guess }
  end

  def game_over
    @miss == 6 || @blank_word.gsub(/\s+/,"") == @hidden_word
  end
  
  def save_game
    t = Time.now 
    Dir.mkdir("saved_games") unless Dir.exists? "saved_games" 
    filename = "saved_games/game_#{t.month}_#{t.day}_#{t.hour}:#{t.min}.json"
    File.open(filename, 'w').write(serialize) 
    puts " Your game has been saved! Goodbye!" 
  end 

  def serialize
    obj = {
      "@hidden_word" => @hidden_word,
      "@blank_word" => @blank_word, 
      "@miss" => @miss, 
      "@guessed" => @guessed, 
    }
    JSON.dump obj
  end

  def saved_games
    saved_list = []
    games = Dir.entries("saved_games").each { |g| saved_list << File.basename(g, ".json") } 
    puts saved_list 
  end

  def load 
    puts " Welcome back! Please select one of the games below by typing in the file name."
    saved_games 
    load_file = gets.chomp
    stored_vars = JSON.load File.read("saved_games/#{load_file}.json")
    stored_vars.keys.each do |key|
      instance_variable_set(key, stored_vars[key])
    end 
  end 

  def play
    welcome 
    choose_word
    display_blank
    puts " Letters to guess: #{@guessed}"
    until game_over do 
      display(@miss)
      guess
      guessed_letters 
      update_blanks 
      puts @blank_word 
      @miss += 1 if !@hidden_word.include? @guess 
    end 
    if @blank_word.gsub(/\s+/,"") == @hidden_word
      puts "You guessed the correct word, #{@hidden_word.upcase}! You win!"
      puts "Flawless victory!" if @miss == 0 
    else 
      display(6) 
      puts "You did not guess the word correctly. The secret word was #{@hidden_word.upcase}. You lose. " 
    end 
    end

end

g = Game.new
g.play  

=begin
1. Display blanks == word length DONE 
2. Accept user guess DONE 
3. Compare guess to word
 3a. If length > 1 compare guess to solution; otherwise compare letter 
4. Identify miss / correct letter DONE
5. Update board / blanks DONE
6. Repeat 2 - 6 DONE
7. Notify user of win or loss DONE
 7b. Tell user winning word if they lost DONE
8. Display letters guessed DONE 
 8b. Allow letter to be guessed only once
9. Save game DONE
10. Load existing game DONE
=end
