module EasyTable

  ESC = "\033"
  CLOSE =  ESC + "[0m"
  CR = "\n"
  SEP = "\t"

  class Color

    attr_reader :code
    def initialize(code,str)
      @code = code
      @str = str
    end
    
    def color
      "\033[" + code.to_s + "m"
    end

    def background
      "\033[" + (code+10).to_s + "m"
    end

    def to_s
      '#<EasyTable::Color:' + @str
    end

    BLACK = Color.new 30,'BLACK'
    RED = Color.new 31,'RED'
    GREEN = Color.new 32,'GREEN'
    YELLOW = Color.new 33,'YELLOW'
    BLUE = Color.new 34,'BLUE'
    MAGENTA = Color.new 35,'MAGENTA'
    CYAN = Color.new 36,'CYAN'
    WHITE = Color.new 37,'WHITE'

  end


  class Style

    attr_accessor :code

    def initialize(code,str)
      @code = code
      @str = str
    end

    def to_s
      '#<EasyTable::Style:' + @str
    end

    BOLD = Style.new "\033[1m",'BOLD'
    UNDERLINE = Style.new "\033[4m",'UNDERLINE'
    BLINK = Style.new "\033[5m",'BLINK'

  end

  class Formattable

    attr_accessor :color
    attr_accessor :background
    attr_accessor :bold
    attr_accessor :underline
    attr_accessor :blink

    def initialize
      @color = nil
      @background = nil
      @style = nil
      @bold = false
      @underline = false
      @blink = false
    end

    def bold?
      bold
    end

    def underline?
      underline
    end

    def blink?
      blink
    end

  end


  class Cell < Formattable

    attr_accessor :value
    attr_accessor :format

    def initialize(value)
      super()
      @value = value
      @format = nil
    end

  end


  class RowGetter < Cell

    def initialize(tab,row)
      @tab = tab
      @row = row
    end

    def [](col)
      cell col
    end

    def cell(col)
      @tab.cell @row,col
    end

    def mnemonic=(mnemonic)
      @tab.set_row_mnemonic @row,mnemonic
    end

    def mnemonics=(mnemonics)
      @tab.set_col_mnemonics mnemonics
    end

    def <<(value)
      add_cell value,nil
    end

    def add_cell(value,mnemonic=nil)
      @tab.add_cell_to_row @row,value,mnemonic
    end

  end

end
