require 'puppet'
require 'puppet/face'
require 'mysql'
require 'active_record'


Puppet::Face.define(:dashboard, '0.0.1') do
  summary   "Query Puppet Dashboard"
  copyright "Kelsey Hightower", 2011
  license   "Apache 2 license"
  
  option "--adapter ADAPTER" do
    summary "Active Record database adapter"
    description <<-'EOT'
      The username for the Puppet Dashboard MySQL database.
    EOT
  end
  option "--database DATBASE" do
    summary "Puppet Dashboard database"
    description <<-'EOT'
			The name of the Puppet Dashboard MySQL database to connect to when
      running queries.
    EOT
  end
  option "--username USER" do
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
    
  def config(options)
    @class    = options[:class]
    @group    = options[:group]
    @user     = options[:username] || Puppet.settings[:dashboard_face_username]
    @password = options[:password] || Puppet.settings[:dashboard_face_password]
    @database = options[:database] || Puppet.settings[:dashboard_face_database]
    @host     = options[:host]     || Puppet.settings[:dashboard_face_host]
    @adapter  = options[:adapter]  || Puppet.settings[:dashboard_face_adapter]
  
    # Setup the active record database connection
    ActiveRecord::Base.establish_connection(
      :adapter  => @adapter,
      :host     => @host,
      :database => @database,
      :username => @user,
      :password => @password
    )
  end
end
