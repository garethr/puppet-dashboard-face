require "puppet/face/dashboard/models.rb"

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
        "nodes"   => DashboardFaceModels::Node,
        "groups"  => DashboardFaceModels::NodeGroup,
        "classes" => DashboardFaceModels::NodeClass
      }
      if table_names.has_key?(kind)
        table_names[kind].select("name").each {|row| puts row.name}
        return
      else
        fail "#{kind} is not a valid search term: [nodes, groups, classes]"
      end
    end
  end
end