class Widget < ActiveRecord::Base
  def self.from_query(query, serverSidePagination)
    widgets = self
    unless query.nil?
      unless query[:search].blank?
        where_query = []
        query[:searchable_columns].each do |column|
          where_query << widgets.arel_table[column.to_sym].matches("%#{query[:search]}%")
        end
        widgets = widgets.where(where_query.inject(&:or))
      end
      unless query[:column_search].blank?
        query[:column_search].each_pair do |column,search|
          unless search.blank?
            widgets = widgets.where(widgets.arel_table[column.to_sym].matches("%#{search}%"))
          end
        end
      end
      unless query[:sort_column].blank? and query[:sort_direction].blank?
        widgets = widgets.order("#{query[:sort_column]} #{query[:sort_direction]}")
      end
      if serverSidePagination
        total_items = widgets.count
        if query[:limit]
          widgets = widgets.limit(query[:limit])
        end
        if query[:offset]
          widgets = widgets.offset(query[:offset])
        end
      end
    end
    if serverSidePagination
      {:total_items => total_items, :items => widgets}
    else
      widgets
    end
  end
end
