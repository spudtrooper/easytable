require 'test/unit'
require File.dirname(__FILE__) + '/../lib/easytable'
include EasyTable

class TestTable < Test::Unit::TestCase

  def test_add_row
    t = Table.new
    assert_equal 0,t.num_rows
    assert_equal 0,t.num_cols
    t.add_row [1,2,3]
    assert_equal 1,t.num_rows
    assert_equal 3,t.num_cols
    t.add_row [4,5,6]
    assert_equal 2,t.num_rows
    assert_equal 3,t.num_cols
    t.add_row [7,8,9]
    assert_equal 3,t.num_rows
    assert_equal 3,t.num_cols
    assert_equal "1 2 3\n4 5 6\n7 8 9",t.to_string
  end

  def test_add_row_operator
    t = Table.new
    assert_equal 0,t.num_rows
    assert_equal 0,t.num_cols
    t << [1,2,3]
    assert_equal 1,t.num_rows
    assert_equal 3,t.num_cols
    t << [4,5,6]
    assert_equal 2,t.num_rows
    assert_equal 3,t.num_cols
    t << [7,8,9]
    assert_equal 3,t.num_rows
    assert_equal 3,t.num_cols
    assert_equal "1 2 3\n4 5 6\n7 8 9",t.to_string
  end

  def test_to_string
    t = Table.new
    assert_equal "",t.to_string
    t << [1,2,3]
    assert_equal "1 2 3",t.to_string
    t << [4,5,6]
    assert_equal "1 2 3\n4 5 6",t.to_string
    t << [7,8,9]
    assert_equal "1 2 3\n4 5 6\n7 8 9",t.to_string
  end

  def test_add_rows
    t = Table.new
    t.add_rows [[1,2,3],
                [4,5,6],
                [7,8,9]]
    assert_equal "1 2 3\n4 5 6\n7 8 9",t.to_string
  end

  def test_from_array
    t = Table.from_array [[1,2,3],
                          [4,5,6],
                          [7,8,9]]
    assert_equal "1 2 3\n4 5 6\n7 8 9",t.to_string
  end

  def test_space
    t = Table.from_array [[1,2,3],
                          [4,5,6],
                          [7,8,9]]
    t.space = '|'
    assert_equal "1|2|3\n4|5|6\n7|8|9",t.to_string
  end

  def test_to_array
    arr = [[1,2,3],
           [4,5,6],
           [7,8,9]]
    t = Table.from_array arr
    assert_equal arr,t.to_array
  end

  def test_to_csv
    arr = [[1,2,3],
           [4,5,6],
           [7,8,9]]
    t = Table.from_array arr
    assert_equal "1\t2\t3\n4\t5\t6\n7\t8\t9",t.to_csv
    assert_equal "1,2,3\n4,5,6\n7,8,9",t.to_csv(',')
  end

  def test_update
    arr = [[1,2,3],
           [4,5,6],
           [7,8,9]]
    t = Table.from_array arr
    assert_equal arr,t.to_array
    t[0][0].value = -1
    t[0][1].value = -2
    t[0][2].value = -3
    t[1][0].value = -4
    t[1][1].value = -5
    t[1][2].value = -6
    t[2][0].value = -7
    t[2][1].value = -8
    t[2][2].value = -9
    arr2 = [[-1,-2,-3],
            [-4,-5,-6],
            [-7,-8,-9]]
    assert_equal arr2,t.to_array
  end

  def test_add_cell
    t = Table.new
    t.add_cell 1
    assert_equal [[1]],t.to_array
    t.add_cell 2
    assert_equal [[1,2]],t.to_array
    t.add_cell 3
    assert_equal [[1,2,3]],t.to_array
    t.new_row
    assert_equal [[1,2,3],[]],t.to_array
    t.add_cell 4
    assert_equal [[1,2,3],[4]],t.to_array
    t.add_cell 5
    assert_equal [[1,2,3],[4,5]],t.to_array
    t.add_cell 6
    assert_equal [[1,2,3],[4,5,6]],t.to_array
  end

  def test_add_cell_2
    t = Table.new
    t << 1
    assert_equal [[1]],t.to_array
    t << 2
    assert_equal [[1,2]],t.to_array
    t << 3
    assert_equal [[1,2,3]],t.to_array
    t.new_row
    assert_equal [[1,2,3],[]],t.to_array
    t << 4
    assert_equal [[1,2,3],[4]],t.to_array
    t << 5
    assert_equal [[1,2,3],[4,5]],t.to_array
    t << 6
    assert_equal [[1,2,3],[4,5,6]],t.to_array
  end

  def test_add_cell_row_operator
    t = Table.new
    t[0] << 1
    assert_equal [[1]],t.to_array
    t[0] << 2
    assert_equal [[1,2]],t.to_array
    t[0] << 3
    assert_equal [[1,2,3]],t.to_array
    t[1] << 4
    assert_equal [[1,2,3],[4]],t.to_array
    t[1] << 5
    assert_equal [[1,2,3],[4,5]],t.to_array
    t[1] << 6
    assert_equal [[1,2,3],[4,5,6]],t.to_array
    t[0] << 7
    assert_equal [[1,2,3,7],[4,5,6]],t.to_array
    t[0] << 8
    assert_equal [[1,2,3,7,8],[4,5,6]],t.to_array
    t[0] << 9
    assert_equal [[1,2,3,7,8,9],[4,5,6]],t.to_array
  end

  def test_new_row
    t = Table.new
    assert_equal [],t.to_array
    t.new_row
    assert_equal [[]],t.to_array
    t.new_row
    assert_equal [[],[]],t.to_array
    t.new_row
    assert_equal [[],[],[]],t.to_array
  end

  def test_add_cell_mnemonics
    t = Table.new
    t.add_cell 'One',:one
    t.add_cell 'Two',:two
    t.add_cell 'Tre',:tre
    assert_equal [['One','Two','Tre']],t.to_array
    t.set_row_mnemonic 0,:header
    assert_equal 'One',t[:header][:one].value
    assert_equal 'Two',t[:header][:two].value
    assert_equal 'Tre',t[:header][:tre].value
    assert_equal 'One',t[0][0].value
    assert_equal 'Two',t[0][1].value
    assert_equal 'Tre',t[0][2].value
  end

  def test_add_row_mnemonics
    t = Table.new
    t.add_row ['One','Two','Tre'],:header
    t.col_mnemonics = [:one, :two, :tre]
    assert_equal [['One','Two','Tre']],t.to_array
    assert_equal 'One',t[:header][:one].value
    assert_equal 'Two',t[:header][:two].value
    assert_equal 'Tre',t[:header][:tre].value
    assert_equal 'One',t.header.one.value
    assert_equal 'Two',t.header.two.value
    assert_equal 'Tre',t.header.tre.value
    assert_equal 'One',t[0][0].value
    assert_equal 'Two',t[0][1].value
    assert_equal 'Tre',t[0][2].value
  end

  def test_add_rows_mnemonics
    t = Table.new
    t.add_row ['One','Two','Tre'],:header
    t.col_mnemonics = [:one, :two, :tre]
    assert_equal [['One','Two','Tre']],t.to_array
    assert_equal 'One',t[:header][:one].value
    assert_equal 'Two',t[:header][:two].value
    assert_equal 'Tre',t[:header][:tre].value
    assert_equal 'One',t.header.one.value
    assert_equal 'Two',t.header.two.value
    assert_equal 'Tre',t.header.tre.value
    assert_equal 'One',t[0][0].value
    assert_equal 'Two',t[0][1].value
    assert_equal 'Tre',t[0][2].value
    t.add_rows({:r1 => [1,2,3]})
    assert_equal 1,t[:r1][:one].value
    assert_equal 2,t[:r1][:two].value
    assert_equal 3,t[:r1][:tre].value
    assert_equal 1,t.r1.one.value
    assert_equal 2,t.r1.two.value
    assert_equal 3,t.r1.tre.value
    assert_equal 1,t[:r1][0].value
    assert_equal 2,t[:r1][1].value
    assert_equal 3,t[:r1][2].value
    assert_equal 1,t[1][0].value
    assert_equal 2,t[1][1].value
    assert_equal 3,t[1][2].value
    t.add_rows({:r2 => [4,5,6]})
    assert_equal 4,t[:r2][:one].value
    assert_equal 5,t[:r2][:two].value
    assert_equal 6,t[:r2][:tre].value
    assert_equal 4,t.r2.one.value
    assert_equal 5,t.r2.two.value
    assert_equal 6,t.r2.tre.value
    assert_equal 4,t[:r2][0].value
    assert_equal 5,t[:r2][1].value
    assert_equal 6,t[:r2][2].value
    assert_equal 4,t[2][0].value
    assert_equal 5,t[2][1].value
    assert_equal 6,t[2][2].value
  end

  def test_add_row_mnemonics_2
    t = Table.new
    t.add_row ['One','Two','Tre'],:header
    t.col_mnemonics = [:one, :two, :tre]
    assert_equal [['One','Two','Tre']],t.to_array
    assert_equal 'One',t[:header][:one].value
    assert_equal 'Two',t[:header][:two].value
    assert_equal 'Tre',t[:header][:tre].value
    assert_equal 'One',t[0][0].value
    assert_equal 'Two',t[0][1].value
    assert_equal 'Tre',t[0][2].value
    t.add_row [1,2,3],:r1
    assert_equal 1,t[:r1][:one].value
    assert_equal 2,t[:r1][:two].value
    assert_equal 3,t[:r1][:tre].value
    assert_equal 1,t[:r1][0].value
    assert_equal 2,t[:r1][1].value
    assert_equal 3,t[:r1][2].value
    assert_equal 1,t[1][0].value
    assert_equal 2,t[1][1].value
    assert_equal 3,t[1][2].value
    t.add_row [4,5,6],:r2
    assert_equal 4,t[:r2][:one].value
    assert_equal 5,t[:r2][:two].value
    assert_equal 6,t[:r2][:tre].value
    assert_equal 4,t[:r2][0].value
    assert_equal 5,t[:r2][1].value
    assert_equal 6,t[:r2][2].value
    assert_equal 4,t[2][0].value
    assert_equal 5,t[2][1].value
    assert_equal 6,t[2][2].value
  end

  def test_add_row_mnemonics_set_mnemonic
    t = Table.new
    t.add_row ['One','Two','Tre'],:header
    t.col_mnemonics = [:one, :two, :tre]
    assert_equal [['One','Two','Tre']],t.to_array
    assert_equal 'One',t[:header][:one].value
    assert_equal 'Two',t[:header][:two].value
    assert_equal 'Tre',t[:header][:tre].value
    assert_equal 'One',t[0][0].value
    assert_equal 'Two',t[0][1].value
    assert_equal 'Tre',t[0][2].value
    t.add_row([1,2,3]).mnemonic = :r1
    assert_equal 1,t[:r1][:one].value
    assert_equal 2,t[:r1][:two].value
    assert_equal 3,t[:r1][:tre].value
    assert_equal 1,t[:r1][0].value
    assert_equal 2,t[:r1][1].value
    assert_equal 3,t[:r1][2].value
    assert_equal 1,t[1][0].value
    assert_equal 2,t[1][1].value
    assert_equal 3,t[1][2].value
    t.add_row([4,5,6]).mnemonic = :r2
    assert_equal 4,t[:r2][:one].value
    assert_equal 5,t[:r2][:two].value
    assert_equal 6,t[:r2][:tre].value
    assert_equal 4,t[:r2][0].value
    assert_equal 5,t[:r2][1].value
    assert_equal 6,t[:r2][2].value
    assert_equal 4,t[2][0].value
    assert_equal 5,t[2][1].value
    assert_equal 6,t[2][2].value
  end

  def test_add_rows_mnemonics_array
    t = Table.new
    t.add_rows({:header => ['One','Two','Tre']})
    assert_equal [['One','Two','Tre']],t.to_array
    assert_equal 'One',t[:header][0].value
    assert_equal 'Two',t[:header][1].value
    assert_equal 'Tre',t[:header][2].value
    assert_equal 'One',t[0][0].value
    assert_equal 'Two',t[0][1].value
    assert_equal 'Tre',t[0][2].value
  end

end
