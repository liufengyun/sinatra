class Company < ActiveRecord::Base
  has_many :persons, :dependent => :destroy

  validates :name, :presence => true, :uniqueness => true
  validates :address, :presence => true
  validates :city, :presence => true
  validates :country, :presence => true
end
