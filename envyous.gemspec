
Gem::Specification.new do |s|
  s.name        = 'envyous'
  s.version     = '1.0.0'
  s.date        = '2015-04-03'
  s.summary     = "Environmentally-friendly config!"
  s.description = "Environmentally-friendly config!"
  s.authors     = ["Brian Lauber"]
  s.email       = 'constructible.truth@gmail.com'
  s.files       = Dir["lib/**/*.rb"]
  s.license     = "MIT"

  s.add_dependency "confickle", '~> 1.0'
  s.add_dependency "rake"
end

