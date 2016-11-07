require 'knife-node-context-exec/version'
require 'chef/knife'

module KnifeNodeContextExec
  # The knife
  class ContextExec < Chef::Knife
    banner 'knife context exec'

    deps do
      require 'chef/search/query'
      require 'knife-node-context-exec/runner'
    end

    option :environment,
           short: '-E ENVIRONMENT',
           long: '--environment ENVIRONMENT',
           description: 'The environment to search.'
    option :node_query,
           short: '-Q QUERY',
           long: '--query QUERY',
           description: 'The node query.'
    option :directory,
           short: '-D DIRECTORY',
           long: '--directory DIRECTORY',
           description: 'A directory for working files.'
    option :template_filename,
           short: '-T TEMPLATE',
           long: '--template TEMPLATE',
           description: 'The filename of a template.'
    option :script_filename,
           short: '-S SCRIPT',
           long: '--script SCRIPT',
           description: 'The environment to search.'
    option :command,
           short: '-C COMMAND',
           long: '--command COMMAND',
           description: 'The command to run.'
    option :filter_regex,
           short: '-R REGEX',
           long: '--regex REGEX',
           description: 'A regex used to filter output.'
    option :parallel,
           short: '-P',
           long: '--parallel',
           description: 'Run in parallel?',
           boolean: true | false,
           default: false

    def run
      puts "knife context exec #{KnifeNodeContextExec::VERSION}"
      environment = config[:environment].to_s
      node_query = config[:node_query].to_s
      directory = config[:directory].to_s
      template_filename = config[:template_filename].to_s
      script_filename = config[:script_filename].to_s
      command = config[:command].to_s
      filter_regex = config[:filter_regex].to_s
      parallel = config[:parallel]
      raise 'Some parameters are missing' if
        environment.empty? || node_query.empty? || directory.empty? || template_filename.empty? ||
        script_filename.empty? || command.empty? || filter_regex.empty?
      directory = File.expand_path(directory)
      template_filename = File.expand_path(template_filename)
      puts "Environment: #{environment}"
      puts "Query:       #{node_query}"
      puts "Directory:   #{directory}"
      puts "Template:    #{template_filename}"
      puts "Script:      #{script_filename}"
      puts "Command:     #{command}"
      puts "Regex:       #{filter_regex}"
      puts "Parallel?    #{parallel}"
      nodes = Chef::Search::Query.new.search(:node, node_query).first.select { |node| node.environment == environment }
      nodes.each { |node| puts "Found node: #{node.name}" }
      KnifeNodeContextExec.run(nodes, directory, template_filename, script_filename, command, filter_regex,
                               parallel, false)
    end
  end
end
