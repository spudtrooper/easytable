module EasyTable

  class Table < Formattable

    attr_writer :out
    attr_accessor :space
    attr_accessor :inplace
    attr_accessor :underline_header
    
    def initialize
      super()
      @rows = []                  
      @mnemonics2rows = {}
      @mnemonics2cols = {}
      @out = STDOUT
      @space = ' '
      @inplace = false
      @rows2cells = {}
      @cols2cells = {}
      @underline_header = false
    end

    def add_rows(valss)
      if valss.instance_of? Array
        valss.each do |vals|
          add_row vals
        end
      elsif valss.instance_of? Hash
        valss.each do |mnemonic,vals|
          add_row vals,mnemonic
        end
      end
    end

    def add_row(vals,mnemonic=nil)
      rows = @rows
      new_row
      if mnemonic
        set_row_mnemonic rows.length-1,mnemonic
      end
      if vals.instance_of? Hash
        vals.each do |mn,val|
          add_cell val,mn
        end
      else
        if !vals.instance_of? Array
          add_cell vals
        else
          vals.each do |val|
            add_cell val
          end
        end
      end
      RowGetter.new self,rows.length-1
    end

    def row(row)
      h = @rows2cells
      i = row_index row
      res = h[i] || RowGetter.new(self,row)
      h[i] = res
    end

    def col(col)
      h = @cols2cells
      i = col_index col
      res = h[i] || Cell.new(nil)
      h[i] = res
    end

    def <<(valss)
      if !valss or !valss.instance_of? Array and !valss.instance_of? Hash
        add_cell valss
      else
        add_row valss
      end
    end
    
    def new_row
      @rows << []
    end

    def add_cell_to_row(row_mnemonic,val,mnemonic=nil)
      rows = @rows
      cur_row = row_index row_mnemonic
      row = rows[cur_row] || []
      row << Cell.new(val)
      rows[cur_row] = row
      if mnemonic
        set_row_mnemonic cur_row,mnemonic
        set_col_mnemonic row.length-1,mnemonic
      end
    end

    def add_cell(val,mnemonic=nil)
      rows = @rows
      cur_row = rows.empty? ? 0 : rows.length-1
      add_cell_to_row cur_row,val,mnemonic
    end

    def set_row_mnemonic(row,n)
      @mnemonics2rows[n] = row
      self.class.send(:define_method, n) {
        row n
      }
    end

    def row_mnemonics=(mnemonics)
      mnemonics.each_index do |row|
        set_row_mnemonic row, mnemonics[row]
      end
    end
    
    def col_mnemonics=(mnemonics)
      mnemonics.each_index do |col|
        set_col_mnemonic col,mnemonics[col]
      end
    end
    
    def set_col_mnemonic(col,n)
      @mnemonics2cols[n] = col
      RowGetter.send(:define_method, n) {
        cell n
      }
    end

    def update_row(row,vals)
      vals.each do |mnemonic,col|
        update_cell row,col,val
      end
    end
    
    def update_cell(row,col,val)
      rows = @rows
      irow = row_index row
      icol = col_index row,col
      cell = rows[irow][icol] || Cell.new(val)
      cell.value = val
      rows[irow][icol] = cell
    end

    def cell(row,col)
      rows = @rows
      irow = row_index row
      icol = col_index row,col
      cell = rows[irow][icol] || Cell.new(nil)
      rows[irow][icol] = cell
    end

    def [](r)
      row r
    end

    def print
      out = @out
      if inplace
        out.print "\033[2J"
        out.print "\0330"
      end
      out.print to_string
      out.flush
    end

    def to_a
      to_array
    end

    def to_array
      @rows.map {|row| row.map {|cell| cell.value}}
    end

    def to_csv(sep=SEP)
      @rows.map {|row| row.map {|cell| cell.value}.join sep}.join "\n"
    end

    def to_html
      rows = @rows
      str = '<table>'
      rows.map do |row|
        str += '<tr>'
        str += row.map {|cell| '<td>' + cell.value.to_s + '</td>'}.join ''
        str += '</tr>'
      end
      str += '</table>'
    end

    def num_rows
      @rows.length
    end

    def num_cols
      rows = @rows
      max = 0
      rows.each do |row|
        max = row.size if row.size>max
      end
      return max
    end
    
    def self.from_array(arr,col_mnemonics=nil)
      t = Table.new
      t.add_rows arr
      t.col_mnemonics = col_mnemonics if col_mnemonics
      return t
    end

    def self.from_file(file,sep=SEP)
      arr = IO.readlines(file).map {|line| line.split /#{SEP}/}
      from_array arr
    end

    def to_s
      to_string
    end

    def to_string
      str = ''
      rows = @rows
      out = @out
      max_col_lengths = []
      rows.each do |row|
        row.each_index do |col|
          max_length = max_col_lengths[col] || 0
          cell= row[col]
          len = cell.value.to_s.length
          max_length = len if len>max_length
          max_col_lengths[col] = max_length
        end
      end
      spc = space.to_s
      rows.each_index do |row|
        r = rows[row]
        #
        # Remember the actual widths for underlining the header
        #
        lengths = []
        #
        # Values
        #
        first = true
        r.each_index do |col|
          c = r[col]
          len = max_col_lengths[col]
          str += spc if not first
          format = c.format ? c.format : '%' + len.to_s + 's'
          s = sprintf format,c.value
          lengths << s.length
          s = add_style s,self
          s = add_style s,@rows2cells[row]
          s = add_style s,@cols2cells[col]
          s = add_style s,c
          str += s
          first = false
        end
        #
        # Maybe underline the header
        #
        first = true
        if row==0 and @underline_header
          str += CR
          r.each_index do |col|
            len = lengths[col]
            str += spc if not first
            str += '-' * lengths[col]
            first = false
          end
        end
        #
        # End of the line
        #
        if row<rows.length-1
          str += CR
        end
      end
      return str
    end

    private

    def add_style(s,c)
      return s if not c
      if c.background
        s = c.background.background + s + CLOSE
      end
      if c.color
        s = c.color.color + s + CLOSE
      end
      if c.bold?
        s = Style::BOLD.code + s + CLOSE
      end
      if c.underline?
        s = Style::UNDERLINE.code + s + CLOSE
      end
      if c.blink?
        s = Style::BLINK.code + s + CLOSE
      end
      return s
    end

    def row_index(n)
      if n.instance_of? Fixnum
        return n
      end
      return @mnemonics2rows[n]
    end

    def col_index(row,n)
      if n.instance_of? Fixnum
        return n
      end
      return @mnemonics2cols[n]
    end
    
  end

end
