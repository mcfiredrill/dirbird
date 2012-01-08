require 'caca'

class Editor
  CHARS = ['█', '▓', '▒', '░', '☺', '☻', '♥', '♦']
  COLORS = [Caca::BROWN,  Caca::GREEN, Caca::LIGHTMAGENTA, Caca::LIGHTBLUE, Caca::MAGENTA, Caca::BLUE,
            Caca::LIGHTRED, Caca::DARKGRAY, Caca::RED, Caca::WHITE, Caca::BLACK, Caca::LIGHTCYAN,
            Caca::LIGHTGRAY, Caca::CYAN, Caca::YELLOW, Caca::LIGHTGREEN]
  MODES = [:normal_mode, :insert_mode, :ex_mode]

  def initialize

    @container = Caca::Canvas.new(120,30)
    @canvas = Caca::Canvas.new(120,30)
    @status_bar = Caca::Canvas.new(50,3)
    @minibuffer = Caca::Canvas.new(80,1)

    @d = Caca::Display.new(@container)
    @d.title= "dirbird"
    @d.refresh

    @d.cursor = 1

    #0-9qwerty change fg_color, shift+0-9qwerty change bg_color
    @bg_color = Caca::RED
    @fg_color = Caca::WHITE
    @cursor_x = 5
    @cursor_y = 5
    @mouse_button_down = false
    @cur_char = 0
    @cur_mode = MODES[0]
    @filename = "" 
    @exmode_str = ""

    @quit = false
  end

  def open(filename)
    @canvas.import_from_file(filename, "utf-8")
  end

  def change_fg_color(chr)
    if chr.match(/[0-9]/)
      color = chr.to_i
    elsif chr == 'q'
      color = 10
    elsif chr == 'w'
      color = 11
    elsif chr == 'e'
      color = 12
    elsif chr == 'r'
      color = 13
    elsif chr == 't'
      color = 14
    elsif chr == 'y'
      color = 15
    end
    COLORS[color]
  end

  def change_bg_color(chr)
    if chr == '!'
      color = 0
    elsif chr == '@'
      color = 1
    elsif chr == '#'
      color = 2
    elsif chr == '$'
      color = 3
    elsif chr == '%'
      color = 4
    elsif chr == '^'
      color = 5
    elsif chr == '&'
      color = 6
    elsif chr == '*'
      color = 7
    elsif chr == '('
      color = 8
    elsif chr == ')'
      color = 9
    elsif chr == 'Q'
      color = 10
    elsif chr == 'W'
      color = 11
    elsif chr == 'E'
      color = 12
    elsif chr == 'R'
      color = 13
    elsif chr == 'T'
      color = 14
    elsif chr == 'Y'
      color = 15
    end
    COLORS[color]
  end

  def change_char(chr)
    if chr == ']'
      if @cur_char < CHARS.length - 1
        @cur_char += 1
      end
    elsif chr == '['
      if @cur_char > 0
        @cur_char -= 1
      end
    end
  end

  def handle_input(e)
    #p e.ch.chr
    case @cur_mode
    when :normal_mode
      if e.down
        @cursor_y += 1
      elsif e.up
        @cursor_y -= 1
      elsif e.left
        @cursor_x -= 1
      elsif e.right
        @cursor_x += 1
      elsif e.draw
        @canvas.put_str(@cursor_x,@cursor_y-4, CHARS[@cur_char])
        #cursor_x+=1
      elsif e.mouse_draw
        @canvas.put_str(@d.mouse_x, @d.mouse_y, CHARS[@cur_char])
      elsif e.change_fg_color
        @fg_color = change_fg_color(e.ch.chr)
      elsif e.change_bg_color
        @bg_color = change_bg_color(e.ch.chr)
      elsif e.change_char
        change_char(e.ch.chr)
      elsif e.enter_insert_mode
        @cur_mode = :insert_mode
      elsif e.erase
        #puts "erase!"
        @canvas.set_color_ansi(Caca::DEFAULT, Caca::DEFAULT)
        @canvas.put_str(@cursor_x, @cursor_y, " ")
      elsif e.ex_mode
        @cur_mode = :ex_mode
        @exmode_str << ":"
        @minibuffer.put_str(0, 0, @exmode_str)
      end
    when :insert_mode
      if e.escape
        @cur_mode = :normal_mode
      elsif e.backspace
        @canvas.set_color_ansi(Caca::DEFAULT, Caca::DEFAULT)
        @canvas.put_str(@cursor_x, @cursor_y, " ")
        @cursor_x-=1
      elsif e.insert_char
        @canvas.put_str(@cursor_x,@cursor_y-4, e.ch.chr)
        @cursor_x+=1
      end
    when :ex_mode
      if e.escape
        @cur_mode = :normal_mode
        @exmode_str = ""
        @minibuffer.clear
      elsif e.enter
        exmode_exec
        @cur_mode = :normal_mode
        @exmode_str = ""
        @minibuffer.clear
      elsif e.backspace
        @exmode_str.chop!
      elsif e.insert_char
        @exmode_str << e.ch.chr
        @minibuffer.put_str(0, 0, @exmode_str)
      end
    end
  end

  def exmode_exec
    t = @exmode_str[1..-1].split(' ')
    #puts t
    if t[0] == "w" || t[0] == "write"
      picture = @canvas.export_to_memory("utf8")
      if @filename == "" && !t[1].nil?
        @filename = t[1]
      end
      File.open(@filename, 'w'){|f| f.write(picture)}
    elsif t[0] == "q" || t[0] == "quit"
      @quit = true 
    end
  end

  def run
    while((e= @d.get_event(Caca::Event, -1)) && !@quit)
      @container.gotoxy(@cursor_x, @cursor_y)
      @canvas.set_color_ansi(@fg_color, @bg_color)

      handle_input(e)
      #p e
      #p e.ch.chr
      #p e.ch.chr
      @status_bar.clear
      @status_bar.set_color_ansi(Caca::WHITE, Caca::BLUE)
      @status_bar.put_str(0,0, "fg_color:#{@fg_color}")
      @status_bar.set_color_ansi(@fg_color, Caca::WHITE)
      @status_bar.put_str(10,0, "█")
      @status_bar.set_color_ansi(Caca::WHITE, Caca::BLUE)
      @status_bar.put_str(0,1, "bg_color:#{@bg_color}")
      @status_bar.set_color_ansi(@bg_color, Caca::WHITE)
      @status_bar.put_str(10,1, "█")
      @status_bar.set_color_ansi(Caca::WHITE, Caca::BLUE)
      @status_bar.put_str(0,2, "block:#{@cur_char}")
      @status_bar.put_str(10,2, CHARS[@cur_char])
      #second column
      @status_bar.put_str(15,0, "canvas_size:#{@canvas.width},#{@canvas.height}")
      if @cur_mode == :insert_mode
        @status_bar.put_str(15,1, "--INSERT--")
      end
      @status_bar.put_str(15,2, "filename:#{@filename}")
      #status_bar.set_color_ansi(Caca::WHITE, Caca::BLUE)
      @container.blit(0, 0, @status_bar)
      @container.blit(0, 4, @canvas)
      @container.blit(0, @container.height-1, @minibuffer)
      @d.refresh
    end
  end
end
