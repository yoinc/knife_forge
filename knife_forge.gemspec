require 'rake'

spec = Gem::Specification.new do |s|
  s.name        = 'knife_forge'
  s.version     = '0.2'
  s.summary     = 'Where knives are made'
  s.description =<<-EOF
command line tool for generating and executing knife commands in batches.
It has the following features:
- build server create commands from a template
- generate serial names from a base name seed
  ex. project-env-task-XXXX
- fork and exectute knives and send their out put to separate named log files
  EOF
  s.email    = 'kirt@airtime.com'
  s.author   = 'Kirt Fitzpatrick'
  s.homepage = 'https://github.com/yoinc/knife_forge'
  s.files    = FileList['lib/**/*.rb', 'bin/*', '[A-Z]*', 'test/**/*'].to_a
  s.executables << 'forge'
  s.add_dependency 'knife-ec2'
end
