require_relative 'square'

class Board
  attr_accessor :squares, :size

  def initialize(size)
    @size = size
    @squares = []
    (1..@size**2).each { |number| squares << Square.new(number) }
  end

  def marker_at(square_number)
    @squares.find { |square| square.number == square_number }.number
  end

  def square_at(square_number)
    @squares.find { |square| square.number == square_number }
  end

  def options
    @squares.map { |square| square.number.to_s }
  end

  def space_empty?(square_number)
    empty_square_numbers.include? square_number
  end

  def place_marker(square_number, marker)
    square_at(square_number).marker = marker
  end

  def empty_squares
    @squares.select { |square| !square.marker } || []
  end

  def empty_square_numbers
    empty_squares.map { |square| square.number }
  end

  def full?
    empty_squares.empty?
  end

  def rows
    ary = []
    @size.times do |row_number|
      ary << select_row(row_number)
    end
    ary
  end

  def cols
    ary = []
    @size.times do |col_number|
      ary << select_col(col_number)
    end
    ary
  end

  def diags
    [falling_diag, rising_diag]
  end

  def all_lines
    rows + cols + diags
  end

  def to_s
    @squares.each do |square|
      print square.to_s
      puts '' if square.number % 3 == 0
    end
  end

  private

  def select_row(row_number)
    @squares.select { |square| (square.number - 1) / @size == row_number }
  end

  def select_col(col_number)
    @squares.select { |square| (square.number - 1) % @size == col_number }
  end

  # UGLY CODE ALERT
  def rising_diag
    ary = []
    row = 0
    col = @size - 1

    @size.times do
      ary << @squares.find do |square|
        (square.number - 1) / @size == row &&
        (square.number - 1) % @size == col
      end
      row += 1
      col -= 1
    end

    ary
  end

  def falling_diag
    @squares.select do |square|
      (square.number - 1) / @size == (square.number - 1) % @size
    end
  end
end
