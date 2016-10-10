class Project < ActiveRecord::Base
  belongs_to :tenant
  validates_uniqueness_of :name
  
    def self.by_plan_and_tenant(tenant_id)
        tenant = Tenant.find(tenant_id)
        tenant.projects
    end
end
