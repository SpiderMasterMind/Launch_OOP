# Launchschool Weekly Challenge 14/5/16 - Hamming Number
class DNA
  attr_accessor :string

  def initialize(string)
    @string = string
  end

  def hamming_distance(sequence)
    hamming_number = 0
    counter = 0
    string.each_char do |char|
      hamming_number += 1 if char != sequence[counter]
      counter += 1
      break if counter == sequence.length
    end
    hamming_number
  end
end
