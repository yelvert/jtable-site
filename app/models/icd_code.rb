class IcdCode < ActiveRecord::Base
=begin
  def self.from_query(query, serverSidePagination)
    icd_codes = self
    unless query.nil?
      unless query[:search].blank?
        search_terms = query[:search].split(" ")
        search_terms.each do |term|
          where_query = []
          query[:searchable_columns].each do |column|
            if icd_codes.arel_table[column.to_sym].column.type == :integer
              where_query << icd_codes.arel_table[column.to_sym].eq(term.to_i)
            else
              where_query << icd_codes.arel_table[column.to_sym].matches("%#{term}%")
            end
          end
          icd_codes = icd_codes.where(where_query.inject(&:or))
        end
      end
      unless query[:column_search].blank?
        query[:column_search].each_pair do |column,search|
          search.split(" ").each do |term|
            icd_codes = icd_codes.where(icd_codes.arel_table[column.to_sym].matches("%#{term}%"))
          end
        end
      end
      unless query[:sort_column].blank? and query[:sort_direction].blank?
        icd_codes = icd_codes.order("#{query[:sort_column]} #{query[:sort_direction]}")
      end
      if serverSidePagination
        total_items = icd_codes.count
        if query[:limit]
          icd_codes = icd_codes.limit(query[:limit])
        end
        if query[:offset]
          icd_codes = icd_codes.offset(query[:offset])
        end
      end
    end
    if serverSidePagination
      {:total_items => total_items, :items => icd_codes}
    else
      icd_codes
    end
  end
=end
end
