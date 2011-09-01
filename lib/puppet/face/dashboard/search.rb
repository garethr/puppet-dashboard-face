require "puppet/face/dashboard/models.rb"

Puppet::Face.define(:dashboard, '0.0.1') do
  action :search do
    summary "Search for nodes in Puppet Dashboard"
    arguments "<kind>"
    description <<-'EOT'
      Search for nodes in Puppet Dashboard by class or group membership.
    EOT
    returns <<-'EOT'
      A list of nodes.
    EOT
    
    examples <<-'EOT'
      Get a list of nodes tagged with the yum class:

      $ puppet dashboard search nodes --class yum

      Get a list of nodes in the QA group:

      $ puppet dashboard search nodes --group QA
      
      Get a list of nodes in the QA group and yum class:
      
      $ puppet dashboard search nodes --class yum --group QA
    EOT

    option "--class CLASS" do
      summary "The Puppet class name"
      description <<-'EOT'
        The Puppet class name to use when searching for nodes in Puppet Dashboard.
      EOT
    end
    option "--group GROUP" do
      summary "Puppet Dashboard group name"
      description <<-'EOT'
        The group name to use when searching for nodes in Puppet Dashboard. 
      EOT
    end

    when_invoked do |kind, options|
      config(options)
      # Right now we only support searching for nodes based on class
      # and group membership.
      if not ['nodes'].include?(kind)
        return "#{kind} is not a valid search term: [nodes]"
      end
      where_clauses = {}
      joins = {}
      if @class
        joins[:node_class_memberships] = :node_class
        where_clauses[:node_classes] = {:name => @class}
      end
      if @group
        joins[:node_group_memberships] = :node_group
        where_clauses[:node_groups] = {:name => @group}
      end
      DashboardFaceModels::Node.joins(joins).where(where_clauses).each {|node| puts node.name}
      return
    end
  end
end