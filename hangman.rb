class Game 
  load "hangman_board.rb" 
  include Board 

  def initialize(word=File.open("5desk.txt"))
    @word = word
    @hidden_word
    @guess 
    @blank_word 
    @miss = 0 
  end 

  def choose_word
    valid_dictionary = @word.select { |line| line if line.chomp.length.between?(5, 12) && line[0] != line[0].upcase }  
    @hidden_word = valid_dictionary[rand(0..valid_dictionary.length-1)].chomp  
  end

  def display_blank 
    puts @blank_word = "_ " * @hidden_word.length 
  end

  def guess
    puts "Enter your guess"
    @guess = gets.chomp
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

  def play
    choose_word
    display_blank
    until game_over do 
      display(@miss)
      guess
      update_blanks 
      puts @blank_word 
      @miss += 1 if !@hidden_word.include? @guess 
    end 
    display(6) if @miss == 6 
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
7. Notify user of win or loss
 7b. Tell user winning word if they lost 
8. Display letters guessed
 8b. Allow letter to be guessed only once
9. Save game
10. Load existing game 
=end
