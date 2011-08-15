require 'puppet/face'
Puppet::Parser::Functions.newfunction(:search_nodes, :type => :rvalue) do |args|

  @doc =  '
Takes a hash of the filters that will be used to create
the list of hosts.

  keys of the form: facts.somefact are filters based on facts
  a key of the form: classes createa filter based on classes
'

  facts_filter = args[0] || {}
  class_filter = facts_filter.delete('classes') || []
  facts_filter.each do |name, value|
    unless name =~ /^facts\./
      raise Puppet::Error, "filter: #{name}, is not prefixed with facts."
    end
  end
  # TODO - support some expiration time
  nodes_1 = Puppet::Face[:facts, :current].search('fake_key', facts_filter)
  nodes_2 = Puppet::Face[:hostclass, :current].search('fake_key', {:classes => class_filter)
  nodes_1 & nodes_2
end
