require "puppet/face/dashboard/models.rb"

Puppet::Face.define(:dashboard, '0.0.1') do
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
      valid_states = [
        :unchanged,
        :unreported,
        :changed,
        :pending,
        :failed,
        :unresponsive
      ]
      if valid_states.include?(status.downcase.to_sym)
        DashboardFaceModels::Node.where("status = '#{status.downcase}'").each do |row|
          puts row.name
        end
        return
      else 
        fail "#{status.downcase.to_s} is not a valid state: [#{valid_states.join(', ')}]"
      end
    end
  end
end