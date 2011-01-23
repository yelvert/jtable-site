(($) ->
  $.jTable =
    defaults:
      settings:
        columns: []
        identifierAttribute: 'id'
        perPage: 25
        fullPagination: true
        ajaxInterval: 250
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
      
      buildAll = =>
        buildTopToolbar()
        buildTable()
        fetchItems()
        
      generateBaseQuery = =>
        searchable_columns = []
        for column in @settings.columns
          if column.searchable
            searchable_columns.push(column.attribute)
        @query.searchable_columns = searchable_columns
        @query.search = ""
        
      fetchItems = =>
        if @query != @previous_query or @query.search == ""
          current_query = $.extend(true, {}, @query)
          ajax = $.ajax({
            url: @settings.indexUrl
            data: {query: current_query}
            cache: false
            success: (data, textStatus, XMLHttpRequest) =>
              updateItems(data)
          })
          @previous_query = $.extend(true, {}, current_query)
        
      updateItems = (items) =>
        @items = []
        for item in items
          @items.push item
        @container.data('jTable').items = @items
        updateTableRows()
        @page = 1
        changePage(1)
        
      buildTopToolbar = =>
        toolbar = $('<div class="ui-toolbar ui-widget-header ui-corner-tl ui-corner-tr ui-helper-clearfix jTable-top-toolbar"></div>')
        @container.append(toolbar)
        buildSearch()
        
      buildTable = =>
        @container.append('<table class="ui-widget"><thead><tr><th></th></tr></thead><tbody></tbody></table>')
        @table = $('table', @element)
        buildTableHead()
        
      buildTableHead = =>
        table_head = $('thead', @table)
        for column in @settings.columns
          th = $('<th class="ui-state-default jTable-column-heading"></th>')
          th.attr('data-jTable-column-attribute', column.attribute)
          if column.heading is undefined
            th.html("<div>#{column.attribute}</div>")
          else
            th.html("<div>#{column.heading}</div>")
          if column.sortable
            $('div',th).append('<span class="css_right ui-icon ui-icon-carat-2-n-s"></span>')
            th.click column.attribute, (event) =>
              $('.jTable-column-heading span').removeClass('ui-icon-triangle-1-n ui-icon-triangle-1-s')
              attribute = event.data
              if @query.sort_column is attribute
                console.log event.target
                if @query.sort_direction is ''
                  @query.sort_direction = 'ASC'
                  $('span', $(event.currentTarget)).addClass('ui-icon-triangle-1-n')
                else if @query.sort_direction is 'ASC'
                  @query.sort_direction = 'DESC'
                  $('span', $(event.currentTarget)).addClass('ui-icon-triangle-1-s')
                else
                  @query.sort_column = ''
                  @query.sort_direction = ''
                  $('span', $(event.currentTarget)).addClass('ui-icon-carat-2-n-s')
              else
                @query.sort_column = attribute
                @query.sort_direction = 'ASC'
                $('span', $(event.currentTarget)).addClass('ui-icon-triangle-1-n')
              fetchItems()
          table_head.append($(th))
        if @settings.editLink or @settings.destroyLink
          table_head.append($('<th class="ui-state-default jTable-column-heading">&nbsp</th>'))
        
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
        
      buildSearch = =>
        $('.jTable-full-search-container.').remove()
        search_field = $('<input type="text" />')
        search_field.keyup =>
          @query.search = search_field.val()
          current_search = String(@query.search)
          setTimeout(=>
            if current_search == search_field.val()
              fetchItems()
          @settings.ajaxInterval)
        search_container = $('<div class="css_left jTable-full-search-container"></div>')
        search_container.html('Search: ')
        search_container.append(search_field)
        $('.jTable-top-toolbar', @container).prepend(search_container)
        
      updatePagination = =>
        $('div.pagination-container', @container).remove()
        page_div = $('<div class="pagination-container"></div>')
        unless (@page-1)*@settings.perPage <= 0
          prev_page_link = $("<a href='#'>Prev</a>")
          prev_page_link.click (event) =>
            changePage(@page-1)
          page_div.append(prev_page_link)
        if @settings.fullPagination
          if Math.ceil(@items.length/@settings.perPage) == 0
            page_link = $("<a data-jTable-pagination-page='#{i}' href='#'>#{i}</a>")
            page_link.click (event) =>
              page = parseInt($(event.target).attr('data-jTable-pagination-page'), 10)
              changePage(page)
            page_div.append(page_link)
          else
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
      @container.addClass('ui-widget jTable-container')
      @items = []
      @container.data('jTable', {})
      @container.data('jTable').settings = @settings
      @previous_query = $.extend(true, {}, @query)
      @table = null
      @page = 1
      buildAll()
      changePage(1)
    
)(jQuery);