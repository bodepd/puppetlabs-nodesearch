require 'puppet/face'
require 'active_record'
require 'puppet/rails'
require 'puppet/rails/resources'

Puppet::Face.define(:hostclass, '0.0.1') do

  Puppet.parse_config

  copyright "Puppet Labs", 2011
  license   "Apache 2 license; see COPYING"

  summary "Search for nodes that have included a class."

  action(:search) do
    summary 'list nodes whose catalog contains a class'
    option '--classes classes' do
      summary 'classes to filter on'
    end
    option '--result_combine operator' do
      summary 'rather to combine searches using and or or'
    end
    when_invoked do |options|
      return [] unless options[:classes]
      klasses = if options[:classes].is_a?(Array)
        options[:classes]
      elsif options[:classes].is_a?(String)
        options[:classes].split(/\s*,\s*/)
      else
      end
      operator = options[:result_combine] ? options[:result_combine].to_sym : :intersection
      Puppet::Rails.init
      nodes = klasses.collect do |class_name|
        nodes = Puppet::Rails::Resources.find_by_sql("SELECT hosts.name as host_name FROM resources INNER JOIN hosts ON hosts.id = resources.host_id WHERE resources.title='#{class_name}' and resources.restype='class';")
        nodes.map { |n| n.host_name }
      end
      if operator == :intersection
        nodes.inject(nodes.flatten.uniq, :&)
      elsif operator == :union
        nodes.flatten.uniq
      else
        raise ArgumentError, "Invaid option for result_combine #{operator}"
      end
    end
  end

end
