(($) ->
  $.jTable =
    defaults:
      settings:
        columns: []
        identifierAttribute: 'id'
        perPage: 25
        fullPagination: true
        indexUrl: ""
        editLink: true
        editUrl: "edit?id=:identifier"
        destroyLink: true
        destroyUrl: "?id=:identifier"
        onDestroy: ->
          alert("Item successfully destroyed.")
      column:
        searchable: true
        sortable: true
        dataType: 'string'
        trueValue: 'True',
        falseValue: 'False'
  
  $.fn.jTable = (options = {}) ->
    this.each ->
      
      generateBaseQuery = =>
        searchable_columns = []
        for column in @settings.columns
          if column.searchable
            searchable_columns.push(column.attribute)
        @query.searchable_columns = searchable_columns
        
      fetchItems = =>
        ajax = $.ajax({
          url: @settings.indexUrl,
          data: {query: @query}
          success: (data, textStatus, XMLHttpRequest) =>
            updateItems(data)
        })
        
      updateItems = (items) =>
        @items = []
        for item in items
          @items.push item
        @container.data('jTable').items = @items
        updateTableRows()
        @page = 1
        changePage(1)
        
      buildTable = =>
        @container.html('<table><thead><tr><th></th></tr></thead><tbody></tbody></table>')
        @table = $('table', @element)
        buildTableHead()
        
      buildTableHead = =>
        table_head = $('thead', @table)
        for column in @settings.columns
          th = $("<th></th>")
          th.attr('data-jTable-column-attribute', column.attribute)
          if column.heading is undefined
            th.html(column.attribute)
          else
            th.html(column.heading)
          th.click column.attribute, (event) =>
            attribute = event.data
            if @query.sort_column is attribute
              if @query.sort_direction is ''
                @query.sort_direction = 'ASC'
              else if @query.sort_direction is 'ASC'
                @query.sort_direction = 'DESC'
              else
                @query.sort_column = ''
                @query.sort_direction = ''
            else
              @query.sort_column = attribute
              @query.sort_direction = 'ASC'
            fetchItems()
          table_head.append($(th))
        if @settings.editLink or @settings.destroyLink
          table_head.append($("<th></th>"))
        
      updateTableRows = =>
        table_body = $('tbody', @table)
        table_body.html('')
        for item, i in @items
          new_row = $("<tr data-jTable-row-index='#{i}'></tr>")
          new_row.attr('data-jTable-item-identifier', item[@settings.identifierAttribute])
          for column in @settings.columns
            new_cell = $('<td></td>')
            new_cell.attr({'data-jTable-cell-attribute': column.attribute, 'data-jTable-cell-value': item[column.attribute]})
            if column.dataType is 'boolean'
              if item[column.attribute]
                new_cell.html(column.trueValue)
              else
                new_cell.html(column.falseValue)
            else
              new_cell.html(item[column.attribute])
            new_row.append(new_cell)
          if @settings.editLink or @settings.destroyLink
            actions_cell = $("<td></td>")
            if @settings.editLink
              edit_link = $("<a>Edit</a>")
              edit_link.attr('href', @settings.editUrl.replace(/\:identifier/, item[@settings.identifierAttribute]))
              actions_cell.append(edit_link)
            if @settings.destroyLink
              destroy_link = $("<a href='#'}>Destroy</a>")
              destroy_link.attr('data-jTable-destroy-url', @settings.destroyUrl.replace(/\:identifier/, item[@settings.identifierAttribute]))
              destroy_link.click (event) =>
                $.ajax({
                  url: $(event.target).attr('data-jTable-destroy-url'),
                  type: 'POST',
                  data: {'_method': 'DELETE'},
                  success: (data, status, xhr) =>
                    @settings.onDestroy(data)
                  ,
                  error: (xhr, status, error) =>
                    element.trigger('ajax:error', [xhr, status, error]);
                })
                fetchItems()
              actions_cell.append(destroy_link)
            new_row.append(actions_cell)
          table_body.append(new_row)
        
      addSearch = =>
        search_field = $('<input type="text" />')
        search_field.keyup =>
          @query.search = search_field.val()
          fetchItems()
        search_container = $('<div></div>')
        search_container.html('Search: ')
        search_container.append(search_field)
        @container.prepend(search_container)
        
      updatePagination = =>
        $('div.pagination-container', @container).remove()
        page_div = $('<div class="pagination-container"></div>')
        unless (@page-1)*@settings.perPage <= 0
          prev_page_link = $("<a href='#'>Prev</a>")
          prev_page_link.click (event) =>
            changePage(@page-1)
          page_div.append(prev_page_link)
        if @settings.fullPagination
          for i in [1..Math.ceil(@items.length/@settings.perPage)]
            page_link = $("<a data-jTable-pagination-page='#{i}' href='#'>#{i}</a>")
            page_link.click (event) =>
              page = parseInt($(event.target).attr('data-jTable-pagination-page'), 10)
              changePage(page)
            page_div.append(page_link)
        unless @items.length <= @page*@settings.perPage
          next_page_link = $("<a href='#'>Next</a>")
          next_page_link.click (event) =>
            changePage(@page+1)
          page_div.append(next_page_link)
        @container.append(page_div)
        
      changePage = (new_page) =>
        @page = new_page
        $('tr[data-jTable-row-index]',@table).hide()
        i = (@page-1)*@settings.perPage
        while (i < @page*@settings.perPage)
          $("tr[data-jTable-row-index='#{i}']",@table).show()
          i++
        updatePagination()
      
      @settings = $.jTable.defaults.settings
      @query = {}
      $.extend true, @settings, options
      for column, i in @settings.columns
        @settings.columns[i] = $.extend true, {}, $.jTable.defaults.column, column
      generateBaseQuery()
      @container = $(this)
      @items = []
      @container.data('jTable', {})
      @container.data('jTable').settings = @settings
      @table = null
      @page = 1
      fetchItems()
      buildTable()
      addSearch()
      changePage(1)
    
)(jQuery);