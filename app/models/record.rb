class Record < ActiveRecord::Base
  belongs_to :type, :class_name => 'RecordType'
  belongs_to :report
  belongs_to :person
end
