class Person < ActiveRecord::Base
  self.table_name = "persons"

  belongs_to :company

  validates :name, :presence => true, :uniqueness => true

  def passport_url
    Configuration.assets_host + "/company/#{self.company.id}/#{self.id}/#{self.passport_file_name}"
  end
end