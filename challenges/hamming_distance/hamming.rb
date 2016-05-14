# Launchschool Weekly Challenge 14/5/16 - Hamming Number
class DNA
  attr_accessor :string

  def initialize(first_string)
    @string = string
  end

  def hamming_distance(second_string)
    hamming_number = 0
    counter = 0
    string.each_char do |char|
      hamming_number += 1 if char != second_string[counter]
      counter += 1
      break if counter == second_string.length
    end
    hamming_number
  end
end
