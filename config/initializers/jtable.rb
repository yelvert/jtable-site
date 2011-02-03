module JTable
  module ActiveRecord
    extend ActiveSupport::Concern
    module ClassMethods
      def jtable(*fields)
        fields.each do |field|
          self.class.instance_eval do
            define_method "jtable_search_#{field}" do |term|
              unless [:date].include? arel_table[field.to_sym].column.type
                if [:integer, :boolean].include? arel_table[field.to_sym].column.type
                  arel_table[field.to_sym].eq(term.to_i)
                else
                  arel_table[field.to_sym].matches("%#{term}%")
                end
              end
            end
            
            define_method "jtable_order_#{field}" do |direction|
              "#{field} #{direction}"
            end
          end
        end
        
        scope :jtable_search, lambda { |search_terms|
          unless search_terms.blank?
            wheres = []
            search_terms.split(" ").each do |term|
              where_query = []
              fields.each do |field|
                where_query << self.send("jtable_search_#{field}", term)
              end
              wheres << where(where_query.inject(&:or))
            end
            wheres.inject(&:&)
          end
        }
        
        scope :jtable_single_search, lambda {|column, search_terms|
          unless column.blank? or search_terms.blank?
            wheres = []
            search_terms.split(" ").each do |term|
              wheres << where(self.send("jtable_search_#{column}", term))
            end
            wheres.inject(&:&)
          end
        }
        
        scope :jtable_order, lambda {|column, direction|
          if !column.blank? and !direction.blank? and %w(asc desc).include?(direction.downcase)
            order(self.send("jtable_order_#{column}", direction))
          end
        }
        
        scope :jtable_paginate, lambda {|per_page, page_start|
          limit(per_page.to_i).offset(page_start.to_i)
        }
        
        scope :jtable_default, lambda {
          
        }
        
        scope :jtable_query, lambda { |jtable_params|
          jtable_params = HashWithIndifferentAccess.new(jtable_params)
          queries = []
          queries << jtable_default()
          queries << jtable_search(jtable_params[:search])
          unless jtable_params[:column_search].blank?
            jtable_params[:column_search].each_pair do |column, search|
              queries << jtable_single_search(column, search)
            end
          end
          queries << jtable_order(jtable_params[:sort_column], jtable_params[:sort_direction])
          queries.inject(&:&)
        }
      end
    end
  end
  
  module ActionController
    def jtable_for_json(rel, jtable_params)
      jtable_params = HashWithIndifferentAccess.new(jtable_params)
      {:total_items => rel.count, :items => rel.jtable_paginate(jtable_params[:limit], jtable_params[:offset])}
    end
  end
end

::ActiveRecord::Base.send(:include, JTable::ActiveRecord)
::ActionController::Base.send(:include, JTable::ActionController)