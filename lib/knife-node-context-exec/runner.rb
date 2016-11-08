require 'open3'
require 'erb'

# Runs commands over a set of nodes
module KnifeNodeContextExec
  # Runs a command in the context of each node
  class NodeRunner
    attr_reader :node, :working_directory, :template_filename, :script_filename, :command, :output

    def initialize(node, working_directory, template_filename, script_filename, command)
      @node = node
      @working_directory = working_directory
      @template_filename = template_filename
      @script_filename = script_filename
      @command = command
    end

    def run
      @thread = Thread.new do
        script_directory = "#{working_directory}/#{node.name}"
        FileUtils.makedirs(script_directory)
        template = File.read(template_filename)
        script = ERB.new(template).result(binding)
        full_script_filename =
          File.join(script_directory, script_filename).gsub(File::SEPARATOR, File::ALT_SEPARATOR || File::SEPARATOR)
        File.open(full_script_filename, 'w') { |file| file.puts(script) }
        cooked_command = command.gsub('%script%', full_script_filename.gsub('\\', '\\\\'))
        @output = []
        yield(">>>> Command: #{cooked_command} <<<<")
        Open3.pipeline_r(cooked_command) do |output, _|
          yield(">>>> Executing process for #{node.name} <<<<")
          output.each_line do |line|
            line.rstrip!
            @output << line
            yield(line)
          end
          yield(">>>> Completed process for #{node.name} <<<<")
        end
      end
      self
    end

    def wait
      @thread.join
      self
    end
  end

  def self.run(nodes, working_directory, template_filename, script_filename, command, filter_regex, parallel, clean)
    FileUtils.makedirs(working_directory)
    temporary_directory = Dir.mktmpdir('x', working_directory)
    nodes = nodes.map do |node|
      node = KnifeNodeContextExec::NodeRunner.new(node, temporary_directory,
                                                  template_filename, script_filename, command).run do |line|
        puts line if line =~ /#{filter_regex}/
      end
      node.wait unless parallel
      node
    end
    nodes.each(&:wait)
    nodes.each do |node|
      puts
      puts "===== FULL OUTPUT - #{node.node.name} ======================"
      node.output.each { |line| puts line }
    end
    FileUtils.remove_dir(working_directory) if clean
  end
end
