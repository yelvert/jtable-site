module ActiveRecord
  class Base
    def self.from_jtable_query(query, serverSidePagination)
      rel = self
      unless query.nil?
        unless query[:search].blank?
          search_terms = query[:search].split(" ")
          search_terms.each do |term|
            where_query = []
            query[:searchable_columns].each do |column|
              if rel.arel_table[column.to_sym].column.type == :integer
                where_query << rel.arel_table[column.to_sym].eq(term.to_i)
              else
                where_query << rel.arel_table[column.to_sym].matches("%#{term}%")
              end
            end
            rel = rel.where(where_query.inject(&:or))
          end
        end
        unless query[:column_search].blank?
          query[:column_search].each_pair do |column,search|
            search.split(" ").each do |term|
              rel = rel.where(rel.arel_table[column.to_sym].matches("%#{term}%"))
            end
          end
        end
        unless query[:sort_column].blank? and query[:sort_direction].blank?
          rel = rel.order("#{query[:sort_column]} #{query[:sort_direction]}")
        end
        if serverSidePagination
          total_items = rel.count
          if query[:limit]
            rel = rel.limit(query[:limit])
          end
          if query[:offset]
            rel = rel.offset(query[:offset])
          end
        end
      end
      if serverSidePagination
        {:total_items => total_items, :items => rel}
      else
        rel
      end
    end
  end
end