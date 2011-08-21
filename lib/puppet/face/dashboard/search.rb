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
        
      if not ['nodes'].include?(kind)
        return "#{kind} is not a valid search term: [nodes]"
      end

      query = <<-'EOT'
      SELECT DISTINCT nodes.name
        FROM (nodes LEFT JOIN node_class_memberships ON node_class_memberships.node_id = nodes.id)
          LEFT JOIN node_classes ON node_class_memberships.node_class_id = node_classes.id
          LEFT JOIN node_group_memberships ON node_group_memberships.node_id = nodes.id
          LEFT JOIN node_groups ON node_group_memberships.node_group_id = node_groups.id
      EOT
      
      if @class and @group.nil?
          where_clause = " WHERE node_classes.name = '#{@class}'"
      elsif @group and @class.nil?
          where_clause = " WHERE node_groups.name = '#{@group}'"
      elsif @class and @group
          where_clause = " WHERE node_classes.name = '#{@class}' AND node_groups.name = '#{@group}'"
      else
          fail "No query params"
      end
      query += where_clause
      query_dashboard_db(query)
    end
  end
end