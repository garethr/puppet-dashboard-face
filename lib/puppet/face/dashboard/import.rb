require 'json'
require "puppet/face/dashboard/models.rb"

Puppet::Face.define(:dashboard, '0.0.1') do
  action :import do
    summary "Import data into puppet dashboard"
    arguments "<data>"
    description <<-'EOT'
      Import ddata into puppet dashboard
    EOT
    returns <<-'EOT'
      Nothing
    EOT
    examples <<-'EOT'
      Import data:

      $ puppet dashboard import data.yaml
    EOT

    when_invoked do |data, options|
      config(options)
      json_data = JSON.load(open(data))

      # Process all node entires
      json_data["node"].each do |nodes|
        nodes.each_key do |name|
          nodes[name].each_pair do |k,v|
            DashboardFaceModels::Node.find_by_name(name.to_s).parameters.create(
              {:key => k, :value => v, :parameterable_type => 'Node'})
          end
        end
      end

      # Process all node group entires
      json_data["group"].each do |groups|
        groups.each_key do |name|
          groups[name].each_pair do |k,v|
            DashboardFaceModels::NodeGroup.find_by_name(name.to_s).parameters.create(
              {:key => k, :value => v, :parameterable_type => 'NodeGroup'})
          end
        end
      end

      return
    end
  end
end