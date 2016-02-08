class Square
  attr_accessor :marker, :number

  def initialize(number)
    @number = number
    @marker = nil
  end

  def to_s
    @marker || number
  end
end
