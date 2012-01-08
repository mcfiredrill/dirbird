Gem::Specification.new do |s|
  s.name        = 'dirbird'
  s.version     = '0.0.0'
  s.date        = '2012-01-02'
  s.summary     = "A ascii/ansi art editor."
  s.description = "A ascii/ansi art editor using the libcaca ruby bindings."
  s.authors     = ["Tony Miller"]
  s.email       = 'mcfiredrill@gmail.com'
  s.homepage    = 'http://github.com/mcfiredrill/dirbird'

  s.require_paths = %w[lib]
  s.executables = ["dirbird"]

  s.files       = %w[
    bin/dirbird
    lib/editor.rb
    lib/events.rb
  ]
end
