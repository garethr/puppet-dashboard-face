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
