require 'caca'

module Caca
  class Event
    def down
    end
    def up
    end
    def left
    end
    def right
    end
    def draw
    end
    def mouse_draw
    end
    def change_fg_color
    end
    def change_bg_color
    end
    def change_char
    end
    def enter_insert_mode
    end
    def escape
    end
    def insert_char
    end
    def erase
    end
    def backspace
    end
    def ex_mode
    end
    def enter

    end
  end
  class Event::Key
    def quit?
      #"".split('').member?(@ch.chr)
    end
  end
  class Event::Key::Press
    def down
      "j".split('').member?(@ch.chr)
    end
    def up
      "k".split('').member?(@ch.chr)
    end
    def left
      "h".split('').member?(@ch.chr)
    end
    def right
      "l".split('').member?(@ch.chr)
    end
    def draw
      " ".split('').member?(@ch.chr)
    end
    def erase
      "x".split('').member?(@ch.chr)
    end
    def change_char
      /[\[\]]/ =~ @ch.chr
    end
    def change_fg_color
      /[0-9qwerty]/ =~ @ch.chr
    end
    def change_bg_color
      /[!@#\$%\^&\*\(\)QWERTY]/ =~ @ch.chr
    end
    def enter_insert_mode
      "i".split('').member?(@ch.chr)
    end
    def escape
      "\e".split('').member?(@ch.chr)
    end
    def backspace
      "\b".split('').member?(@ch.chr)
    end
    def insert_char
      /./ =~ @ch.chr
    end
    def ex_mode
      ":".split('').member?(@ch.chr)
    end
    def enter
      "\r".split('').member?(@ch.chr)
    end
  end
  class Event::Mouse::Press
    def mouse_draw
      return @button==1
    end
  end
  class Event::Mouse::Release
    def mouse_release
      return @button==1
    end
    def erase
      return @button==2
    end
  end
  class Event::Mouse::Motion
    def mouse_drawing
      return $mouse_button_down
    end
  end
end
