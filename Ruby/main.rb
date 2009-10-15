# To change this template, choose Tools | Templates
# and open the template in the editor.

# puts "Hello World"
# puts "It is now #{Time.now}"

class Book
   # Constructor Method
    def initialize(isbn, price)
      @isbn = isbn
      @price = Float(price)
    end

    # attr_reader :isbn, :price
    # shortcut for the following Getters
    def isbn
      @isbn
    end

    def price
      @price
    end

    # setters
    # attr_accessor :price
    def price=(new_price)
      @price=new_price
    end

    def to_s
      "ISBN: #{@isbn}, price: #{@price}"
    end
end

a = Book.new("isbn1", 3)
puts a.to_s
b = Book.new("isbn3", 12)
puts b.to_s
a.price=(a.price*0.75)
puts a
