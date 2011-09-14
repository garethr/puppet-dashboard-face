require 'rubygems'
require 'active_record'
require 'logger'

module DashboardFaceModels
  class Node < ActiveRecord::Base
    validates_presence_of :name
    validates_uniqueness_of :name

    has_many :node_class_memberships
    has_many :node_classes, :through => :node_class_memberships

    has_many :node_group_memberships
    has_many :node_groups,  :through => :node_group_memberships

    has_many :parameters,   :as => :parameterable
  end

  class NodeClass < ActiveRecord::Base
    has_many :node_class_memberships
    has_many :nodes, :through => :node_class_memberships
  end

  class NodeGroup < ActiveRecord::Base
    has_many :node_group_class_memberships
    has_many :node_classes, :through => :node_group_class_memberships

    has_many :node_group_memberships
    has_many :nodes, :through => :node_group_memberships

    has_many :parameters, :as => :parameterable
  end

  class Parameter < ActiveRecord::Base
    belongs_to :parameterable, :polymorphic => true
  end

  class NodeClassMembership < ActiveRecord::Base
    belongs_to :node
    belongs_to :node_class
  end

  class NodeGroupMembership < ActiveRecord::Base
    belongs_to :node
    belongs_to :node_group
  end

  class NodeGroupClassMembership < ActiveRecord::Base
    belongs_to :node_class
    belongs_to :node_group
  end
end