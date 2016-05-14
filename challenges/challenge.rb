
require 'pry'
def gcd(num1, num2)
array1 = (1..num1).to_a.select do |number1|
  num1 % number1 == 0
end

array2 = (1..num2).to_a.select do |number2|
  num2 % number2 == 0
end

[array1, array2].max#
end

p gcd(9, 15)