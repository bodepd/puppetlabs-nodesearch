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
  #expiration_time = args[2] || 60
  # TODO - support some expiration time
  facts_search_nodes = Puppet::Face[:facts, :current].search('fake_key', {:extra => facts_filter})
  class_search_nodes = Puppet::Face[:hostclass, :current].search({:classes => class_filter})
  if facts_filter.empty? or class_filter.empty?
    facts_search_nodes | class_search_nodes
  else
    facts_search_nodes & class_search_nodes
  end
end
