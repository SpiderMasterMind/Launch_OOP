
class Anagram
  attr_accessor :word
  def initialize(string)
    @word = string
  end

  def match(array)
    result = array.select do |element|
      word.downcase.split('').sort == element.downcase.split('').sort && element.downcase != word
    end
    result.delete_if { |element| word == element }
  end
end
