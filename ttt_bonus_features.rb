require 'pry'

def joinor(array, seperator=', ' , last='or')
  string = ''
  array_length = array.count
  i = 1

  array.each do |value|
    if i < array.length
      string = string + value.to_s + seperator
    else
      string = string + last + ' ' + value.to_s
    end
    i += 1
  end

  return string
end

p joinor([1, 2, 3], ', ', 'and')

p joinor(['Joe', 'Greg', 'Joss', 'Jack', 'Lee'])
