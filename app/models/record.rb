class Record < ActiveRecord::Base
  belongs_to :type, :class_name => 'RecordType'
  belongs_to :report
end
