class PerfectNumber

  def self.classify(number)
    raise RuntimeError, 'RuntimeError' unless number > 0
    get_number_classification(number)
  end

  def self.get_number_classification(number)
    return "perfect" if number == 1    
    process_result(number, sum_of_divisors(number))
  end

  def self.sum_of_divisors(number)
    result = []
    1.upto(number - 1) { |integer| result << integer if number % integer == 0 }
    result.inject(:+)
  end

  def self.process_result(number, sum)
    if product > number
      "abundant"
    elsif product < number
      "deficient"
    else "perfect"
    end
  end
end
