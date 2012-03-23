spec = Gem::Specification.new do |s|
  s.name    = 'knife_forge'
  s.version = '0.1'
  s.summary = 'Where knives are made'
  s.author  = 'Kirt Fitzpatrick'
  s.files   = [
    'lib/*',
    'lib/knife_forge/*',
  ]
  s.executables << 'forge'
  s.add_dependency 'knife-ec2'
end
