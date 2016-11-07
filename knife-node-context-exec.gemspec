$LOAD_PATH << File.expand_path('../lib', __FILE__)
Gem::Specification.new do |specification|
  specification.name = 'knife-node-context-exec'
  specification.version = '1.0.0'
  specification.authors = ['Andrew Heald']
  specification.email = 'andrew@heald.uk'
  specification.homepage = 'https://github.com/sappho/knife-node-context-exec'
  specification.summary = 'Runs a search against Chef server and executes a command for each returned node'
  specification.description = 'Runs a search against Chef server and executes a command for each returned node. ' \
                              'See the project home page for more information.'
  specification.files = Dir['lib/**/*']
  specification.require_paths = %w(lib)
end
