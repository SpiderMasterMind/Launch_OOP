require 'pry'
class Diamond
  LETTERS = ["a", "b", "c", "d", "e"]
  attr_accessor :width, :letters_array, :target_char

  def self.make_diamond(char)
    width = find_width(char)
    letters_array = make_array(char)

    target_char = char

    result = letters_array.map do |letters|
      inner_pad(letters)
      outer_pad(letters)# - this method is ready to go
    end
    p result
  end


  def self.find_inner_pad(letter_on_line)
    if LETTERS.index(letter_on_line) == 0
      return 0
    else

      LETTERS.index(letter_on_line) * 2 - 1
    end

  end

  def self.inner_pad(letters)
    return "a" if letters[0] == "a"
    result = []
    result << letters[0]
    result << " " * find_inner_pad(letters[0])
    result << letters[1]
    result.join

  end

  def self.outer_pad(letter_on_line)
    if letter_on_line == "a"
       width - 1
    else
      result = width - find_inner_pad(letter_on_line)
      result / 2
    end
  end

  def self.make_array(char)
    index_of_target_letter = LETTERS.index(char)

    array = LETTERS[0..index_of_target_letter]
    array.map.with_index do |element, index|
      if index > 0
        element + element
      else element
      end
    end

  end

  def self.find_width(char)
    LETTERS.index(char) * 2 + 1
  end

end

test = Diamond.make_diamond("e")

