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
    environment = config[:environment].to_s
    nodes = Chef::Search::Query.new.search(:node, config[:node_query].to_s).first.select do |node|
      node.environment == environment
    end
    KnifeNodeContextExec.run(nodes, config[:directory].to_s, config[:template_filename].to_s,
                             config[:script_filename].to_s, config[:command].to_s, config[:filter_regex].to_s,
                             config[:parallel].to_s == 'true', false)
  end
end
