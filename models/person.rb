class Person < ActiveRecord::Base
  self.table_name = "persons"

  belongs_to :company

  validates :name, :presence => true, :uniqueness => { :scope => :company_id }
  validates :company, :presence => true

  before_destroy :delete_passport_file!

  # don't protect passport for now as we have no authentication system
  def passport_url
    S3.object_url(self.passport_s3_key)
  end

  def passport_s3_key
    "company/#{self.company_id}/#{self.id}/passports/#{self.passport_file_name}"
  end

  def passport_s3_upload_key
    "company/#{self.company_id}/#{self.id}/passports/${filename}"
  end

  def passport_exists?
    self.passport_file_name.present?
  end

  def as_json(options = {})
    if self.passport_file_name.present? 
      passport_hash = {passport_url: self.passport_url}
    else
      passport_hash = {}
    end

    super(options).merge(passport_hash)
  end

  # delete s3 file
  def delete_passport_file!
    unless self.passport_file_name.blank?
      S3.delete_object(self.passport_s3_key)
    end
  end
end
