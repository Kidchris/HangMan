require "yaml"
# ########### Loading the data ########

words = open("./file.txt", "r").readlines.select!{|w| w.downcase.strip!.length.between?(5, 10)}.to_a
puts words.is_a? Array
# Defining the fundamentals functions
def saver(word, chances, rep)

    saved = rep.length

    dumper = YAML.dump({ 
        word: word,
        replacer: rep,
        chances: rep.split("").each.select! {|e| e !="-" }.length
    })

    file = File.open("./data/#{saved}_#{word[-1]}.yml", "w").write(dumper)
    puts "Data saved successfully"
end

def play(word_list, replacer="", chances="", word="")

    word.empty? ? guess = word_list.sample.strip : guess=word
    replacer.empty? ? replacer = "-" * guess.length : replacer= replacer
    chances.to_s.empty? ? chances = (guess.length + 1) : chances=chances.to_i

    letters = guess.split("")

    until replacer.downcase == guess.downcase
      puts "\e[34mRemaining Chances : \e[0m"  << "\e[31m#{chances}\e[0m"
      puts "Try to guess the letter or type \"quit\" to quit and save the game"

      guessed_word = gets.chomp

      if letters.include?(guessed_word)
        index = letters.each_index.select{|i| letters[i] == guessed_word}
        index.each{|el| replacer[el]=guessed_word}
        puts replacer

      elsif guessed_word.downcase.strip == "quit"
        saver(guess, chances, replacer)
        break

      else
        chances -=1
        puts replacer

      end

      break if chances ==0

    end

    puts "\e[32m#{guess.upcase}\e[0m" << " was the right word"

end

def replay(name)

 data = File.open("./data/#{name}.yml", "r")
 game = YAML.load data
 game
 
end

puts "Do you want to : "<< "1) Start a new game", "\t\t 2) Load an existing game"

choice = gets.chomp

case choice

when "1"

    play(words)

when "2"

    puts "Choose the game you wnat to reload:"
    gamed = Dir.glob("./data/*.yml")
    saved_names = gamed.each { |n|  n.delete_prefix!("./data/").delete_suffix!(".yml") }
    saved_names.each_with_index { |name, index| puts "#{index}) #{name}"}
    choosed_name = gets.chomp.to_i
    
    until choosed_name < saved_names.length

        puts "Make a right choice "
        choosed_name = gets.chomp.to_i

    end
    
    replayer = replay(saved_names[choosed_name])

    rp = replayer[:replacer]
    ch = replayer[:chances]
    wd = replayer[:word]
    
    play(words, replacer=rp, chances=ch, word=wd)
end