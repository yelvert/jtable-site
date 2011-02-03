class IcdCode < ActiveRecord::Base
  jtable :identifier, :short_description, :description, :code_type, :mcc, :cc, :activated, :deactivated
end
