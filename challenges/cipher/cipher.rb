# fix test errors
class Cipher
  attr_accessor :key
  ALPHABET = ('a'..'z').to_a

  def initialize(key = 'aaaaaaaaaa')
    raise ArgumentError if key == '' || key.match(/[A-Z]|\d/)
    @key = key || generate_key
  end

  def encode(text)
    result = ''
    text.chars.each_with_index do |letter, idx|
      result << rotate_and_get_letter(find_shift_amount(idx), letter)
    end
    result
  end

  def decode(text)
    result = ''
    text.chars.each_with_index do |letter, idx|
      result << derotate_and_get_letter(find_shift_amount(idx), letter)
    end
    result
  end

  def find_shift_amount(idx)
    ALPHABET.index(key[idx])
  end

  def rotate_and_get_letter(shift_amount, letter)
    ALPHABET.rotate(shift_amount)[ALPHABET.index(letter)]
  end

  def derotate_and_get_letter(shift_amount, letter)
    ALPHABET.rotate((-1 * shift_amount))[ALPHABET.index(letter)]
  end

  private

  def generate_key
    (('a'..'z').to_a.shuffle * 4).pop(100).join
  end
end
