require 'knife-node-context-exec/version'

# The knife
class ContextExec < Chef::Knife
  banner 'knife context exec'

  deps do
    require 'chef/search/query'
    require 'knife-node-context-exec/runner'
  end

  option :environment,
         short: '-E',
         long: '--environment',
         description: 'The environment to search.'
  option :node_query,
         short: '-Q',
         long: '--query',
         description: 'The node query.'
  option :directory,
         short: '-D',
         long: '--directory',
         description: 'A directory for working files.'
  option :template_filename,
         short: '-T',
         long: '--template',
         description: 'The filename of a template.'
  option :script_filename,
         short: '-S',
         long: '--script',
         description: 'The environment to search.'
  option :command,
         short: '-C',
         long: '--command',
         description: 'The command to run.'
  option :filter_regex,
         short: '-R',
         long: '--regex',
         description: 'A regex used to filter output.'
  option :parallel,
         short: '-P',
         long: '--parallel',
         description: 'Run in parallel?'

  def run
    puts "knife context exec #{KnifeNodeContextExec::VERSION}"
    environment = config[:environment].to_s
    node_query = config[:node_query].to_s
    directory = config[:directory].to_s
    template_filename = config[:template_filename].to_s
    script_filename = config[:script_filename].to_s
    command = config[:command].to_s
    filter_regex = config[:filter_regex].to_s
    parallel = config[:parallel].to_s
    puts "Environment: #{environment}"
    puts "Query:       #{node_query}"
    puts "Directory:   #{directory}"
    puts "Template:    #{template_filename}"
    puts "Script:      #{script_filename}"
    puts "Command:     #{command}"
    puts "Regex:       #{filter_regex}"
    puts "Parallel?    #{parallel}"
    nodes = Chef::Search::Query.new.search(:node, node_query).first.select do |node|
      node.environment == environment
    end
    nodes.each { |node| puts "Found #{node.name}" }
    KnifeNodeContextExec.run(nodes, directory, template_filename, script_filename, command, filter_regex,
                             parallel == 'true', false)
  end
end
