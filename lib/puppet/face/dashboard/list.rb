Puppet::Face.define(:dashboard, '0.0.1') do
  action :list do
    summary "List nodes, groups, and classes in Puppet Dashboard"
    arguments "<kind>"
    description <<-'EOT'
      List nodes, groups, and classes in Puppet Dashboard
    EOT
    returns <<-'EOT'
      A list of nodes, groups, or classes.
    EOT
    examples <<-'EOT'
      Get a list of nodes:
      
      $ puppet dashboard list nodes
      
      Get a list of groups:
      
      $ puppet dashboard list groups
      
      Get a list of classes:
      
      $ puppet dashboard list classes
    EOT

    when_invoked do |kind, options|
      config(options)
      table_names = { 
        "nodes"   => "nodes",
        "groups"  => "node_groups",
        "classes" => "node_classes"
      }
      if table_names.has_key?(kind)
        query = "SELECT name from #{table_names[kind]}"
        query_dashboard_db(query)
      else
        fail "#{kind} is not a valid search term: [nodes, groups, classes]"
      end
    end
  end
end