class Report < ActiveRecord::Base
  belongs_to :location
  belongs_to :event
  has_many :records, :dependent => :destroy
end
