require 'puppet'
require 'puppet/face'
require 'mysql'

Puppet::Face.define(:dashboard, '0.0.1') do
  summary   "Query Puppet Dashboard"
  copyright "Kelsey Hightower", 2011
  license   "Apache 2 license"

  option "--database DATBASE" do
    summary "Puppet Dashboard database"
    description <<-'EOT'
      The name of the Puppet Dashboard MySQL database to connect to when
      running queries.
    EOT
  end

  option "--user USER" do
    summary "Puppet Dashboard database username"
    description <<-'EOT'
      The username for the Puppet Dashboard MySQL database.
    EOT
  end

  option "--password PASSWORD" do
    summary "Puppet Dashboard database password"
    description <<-'EOT'
      The password for the Puppet Dashboard MySQL database.
    EOT
  end

  option "--host HOST" do
    summary "Puppet Dashboard database hostname"
    description <<-'EOT'
      The hostname for the Puppet Dashboard database.
    EOT
  end

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
      
      table_names = { "nodes" => "nodes", "groups" => "node_groups", "classes" => "node_classes" }
      if table_names.has_key?(kind)
        query = "SELECT name from #{table_names[kind]}"
        query_dashboard_db(query)
      else
        fail "#{kind} is not a valid search term: [nodes, groups, classes]"
      end
    end
  end
  
  action :report do
    summary "Report node status"
    arguments "<status>"
    description <<-'EOT'
      List nodes by status: unchanged, unreported, changed, pending, failed,
      or unresponsive.
    EOT
    returns <<-'EOT'
      A list of nodes.
    EOT
    
    examples <<-'EOT'
    
    Get a list of nodes currently are failing:
    
    $ puppet dashboard report failed
    
    Get a list of nodes with changes:
    
    $ puppet dashboard report changed
    EOT
    
    when_invoked do |status, options|
      config(options)
      
      valid_states = [:unchanged, :unreported, :changed, :pending, :failed, :unresponsive]
      
      if valid_states.include?(status.downcase.to_sym)
        query = <<-EOT
          SELECT DISTINCT name FROM nodes WHERE status = '#{status.downcase}'
        EOT
        query_dashboard_db(query)
      else 
        fail "#{status.downcase.to_s} is not a valid search term: [changed, failed, pending, unchanged, unreported, unresponsive]"
      end
    end
  end
    
  def config(options)
    @class = options[:class]
    @group = options[:group]
    @user = options[:user]
    @password = options[:password]
    @database = options[:database]
    @host = options[:host]
  end

  def query_dashboard_db(query)
    mysql = Mysql.init()
    mysql.connect(@host, @user, @password, @database)
    results = mysql.query(query)
    results.each do |row|
      puts row[0]
    end
    mysql.close()
    return
  end

end
