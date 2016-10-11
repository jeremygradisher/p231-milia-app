class Project < ActiveRecord::Base
  belongs_to :tenant
  has_many :artifacts, dependent: :destroy
  validates_uniqueness_of :name
  
    def self.by_plan_and_tenant(tenant_id)
        tenant = Tenant.find(tenant_id)
        tenant.projects
    end
end
