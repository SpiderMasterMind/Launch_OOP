require 'pry'
class Diamond
  LETTERS = ["a", "b", "c", "d", "e"]


  def make_diamond(char)
    array = make_array(char)
    width = find_width(char)

  #  array.map  do |letter_group|
   #   letter_group.add_inner_pad(width)
    #  letter_group.add_outerpad
     # letter_group.add_newline

    # end
  end


  def find_inner_pad(letter_on_line)
    if LETTERS.index(letter_on_line) == 0
      return 0
    else

      LETTERS.index(letter_on_line) * 2 - 1
    end

  end

  def inner_pad(string)
    result = []
    result << string[0]
    result << " " * find_inner_pad(string[0])
    result << string[1]
    result.join

  end

  def find_outer_pad(letter_on_line)
    if LETTERS.index(letter_on_line) == 
    end
  end



  def make_array(char)
    index_of_target_letter = LETTERS.index(char)

    array = LETTERS[0..index_of_target_letter]
    array.map.with_index do |element, index|
      if index > 0
        element + element
      else element
      end
    end

  end

  def find_width(char)
    LETTERS.index(char) * 2 + 1
  end

  def find_inner_padding_of_line()
  end
end

test = Diamond.new
p test.inner_pad("ee")
p test.outer_pad("dd")
# get value of letter
# this is the total length of each line + \n
  # a => "A\n"
 # form array of letters, each with index up to target letter, then some sort of EWI backwards


# find width of square
# subtract 1 or 2 (for characters)
# inner padding is letter index + 2
# outer padding is width - inner - (1 or 2)
# 1,3,5,7,9
# 0,1,2,3,4
