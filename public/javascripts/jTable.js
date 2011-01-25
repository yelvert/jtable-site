/* DO NOT MODIFY. This file was compiled Tue, 25 Jan 2011 22:52:25 GMT from
 * /Users/yelvert/projects/jtable/app/coffeescripts/jTable.coffee
 */

var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
(function($) {
  $.jTable = {
    defaults: {
      settings: {
        columns: [],
        identifierAttribute: 'id',
        singleColumnSearch: false,
        perPage: 25,
        fullPagination: true,
        serverSidePagination: false,
        ajaxInterval: 250,
        noItemsMsg: "No Records were found.",
        rowClass: '',
        width: '',
        indexUrl: '',
        editLink: true,
        editUrl: 'edit?id=:identifier',
        destroyLink: true,
        destroyUrl: '?id=:identifier',
        onDestroy: function() {
          return alert('Item successfully destroyed.');
        }
      },
      column: {
        searchable: true,
        sortable: true,
        dataType: 'string',
        trueValue: 'True',
        falseValue: 'False',
        columnClass: ''
      }
    }
  };
  return $.fn.jTable = function(options) {
    if (options == null) {
      options = {};
    }
    return this.each(function() {
      var buildAll, buildBottomToolbar, buildSearch, buildTable, buildTableFoot, buildTableHead, buildTopToolbar, changePage, column, fetchItems, generateBaseQuery, i, updateItems, updatePageInfo, updatePagination, updateTableRows, _len, _ref;
      buildAll = __bind(function() {
        buildTopToolbar();
        buildTable();
        buildBottomToolbar();
        return fetchItems();
      }, this);
      generateBaseQuery = __bind(function() {
        var column, searchable_columns, _i, _len, _ref;
        searchable_columns = [];
        _ref = this.settings.columns;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          column = _ref[_i];
          if (column.searchable) {
            searchable_columns.push(column.attribute);
          }
        }
        this.query.searchable_columns = searchable_columns;
        this.query.search = "";
        this.query.limit = this.settings.perPage;
        this.query.offset = 0;
        return this.query.column_search = {};
      }, this);
      fetchItems = __bind(function() {
        var ajax, current_query;
        if (this.query !== this.previous_query || this.query.search === "") {
          current_query = $.extend(true, {}, this.query);
          this.stale_paging = false;
          ajax = $.ajax({
            url: this.settings.indexUrl,
            data: {
              jTableQuery: current_query
            },
            cache: false,
            success: __bind(function(data, textStatus, XMLHttpRequest) {
              updateItems(data);
              return this.initial_load = false;
            }, this)
          });
          return this.previous_query = $.extend(true, {}, current_query);
        }
      }, this);
      updateItems = __bind(function(data) {
        var item, items, _i, _len;
        if (this.settings.serverSidePagination) {
          this.items_count = data.total_items;
          items = data.items;
        } else {
          this.items_count = data.length;
          items = data;
          this.page = 1;
        }
        this.items = [];
        for (_i = 0, _len = items.length; _i < _len; _i++) {
          item = items[_i];
          this.items.push(item);
        }
        this.container.data('jTable').items = this.items;
        updateTableRows();
        return changePage(this.page);
      }, this);
      buildTopToolbar = __bind(function() {
        var toolbar;
        toolbar = $('<div class="jTable-top-toolbar"></div>');
        this.container.append(toolbar);
        return buildSearch();
      }, this);
      buildTable = __bind(function() {
        this.container.append('<div class="jTable-table-container"><table class="jTable-table"><thead></thead><tbody></tbody><tfoot></tfoot></table></div>');
        this.table = $('table', this.container);
        buildTableHead();
        if (this.settings.singleColumnSearch) {
          return buildTableFoot();
        }
      }, this);
      buildTableHead = __bind(function() {
        var column, table_head, th, _i, _len, _ref;
        table_head = $('thead', this.table);
        _ref = this.settings.columns;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          column = _ref[_i];
          th = $('<th class="jTable-column-heading"></th>');
          th.attr('data-jTable-column-attribute', column.attribute);
          if (column.heading === void 0) {
            th.html("<div>" + column.attribute + "</div>");
          } else {
            th.html("<div>" + column.heading + "</div>");
          }
          if (column.sortable) {
            $('div', th).append('<span class="jTable-sort jTable-sort-none"></span>');
            th.click(__bind(function(event) {
              var attribute, sort_icon;
              $('.jTable-column-heading span', this.container).removeClass('jTable-sort-asc jTable-sort-desc');
              attribute = $(event.currentTarget).attr('data-jTable-column-attribute');
              sort_icon = $('span', $(event.currentTarget));
              if (this.query.sort_column === attribute) {
                if (this.query.sort_direction === '') {
                  this.query.sort_direction = 'ASC';
                  sort.addClass('jTable-sort-asc');
                } else if (this.query.sort_direction === 'ASC') {
                  this.query.sort_direction = 'DESC';
                  sort_icon.addClass('jTable-sort-desc');
                } else {
                  this.query.sort_column = '';
                  this.query.sort_direction = '';
                  sort_icon.addClass('jTable-sort-none');
                }
              } else {
                this.query.sort_column = attribute;
                this.query.sort_direction = 'ASC';
                sort_icon.addClass('jTable-sort-asc');
              }
              return fetchItems();
            }, this));
          }
          table_head.append($(th));
        }
        if (this.settings.editLink || this.settings.destroyLink) {
          return table_head.append($('<th class="jTable-column-heading">&nbsp</th>'));
        }
      }, this);
      buildTableFoot = __bind(function() {
        var column, search_field, table_foot, th, _i, _len, _ref;
        if (this.settings.singleColumnSearch) {
          table_foot = $('tfoot', this.table);
          _ref = this.settings.columns;
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            column = _ref[_i];
            if (column.searchable) {
              th = $('<th class="jTable-column-footer"></th>');
              search_field = $("<input type='text' jTable-column-attribute='" + column.attribute + "'>");
              search_field.keyup(__bind(function(event) {
                var attribute, current_search, field;
                field = $(event.currentTarget);
                attribute = field.attr('jTable-column-attribute');
                this.query.column_search[attribute] = field.val();
                current_search = String(this.query.column_search[attribute]);
                return setTimeout(__bind(function() {
                  if (current_search === field.val()) {
                    this.page = 1;
                    this.query.offset = 0;
                    return fetchItems();
                  }
                }, this), this.settings.ajaxInterval);
              }, this));
              th.append(search_field);
            } else {
              th = $('<th class="jTable-column-footer">&nbsp;</th>');
            }
            table_foot.append(th);
          }
          if (this.settings.editLink || this.settings.destroyLink) {
            return table_foot.append($('<th class="jTable-column-footer">&nbsp;</th>'));
          }
        }
      }, this);
      updateTableRows = __bind(function() {
        var actions_cell, blank_row, column, column_count, destroy_link, edit_link, i, item, new_cell, new_row, table_body, _i, _len, _len2, _ref, _ref2, _results;
        table_body = $('tbody', this.table);
        table_body.html('');
        if (this.items_count === 0) {
          column_count = this.settings.columns.length;
          if (this.settings.editLink || this.settings.destroyLink) {
            column_count += 1;
          }
          blank_row = $("<tr><td colspan='" + column_count + "' class='jTable-cell jTable-no-items-row'>" + this.settings.noItemsMsg + "</td></tr>");
          return table_body.append(blank_row);
        } else {
          _ref = this.items;
          _results = [];
          for (i = 0, _len = _ref.length; i < _len; i++) {
            item = _ref[i];
            new_row = $("<tr data-jTable-row-index='" + i + "'></tr>");
            if (i % 2 === 0) {
              new_row.addClass("jTable-row-even");
            } else {
              new_row.addClass("jTable-row-odd");
            }
            new_row.addClass(this.settings.rowClass);
            new_row.attr('data-jTable-item-identifier', item[this.settings.identifierAttribute]);
            _ref2 = this.settings.columns;
            for (_i = 0, _len2 = _ref2.length; _i < _len2; _i++) {
              column = _ref2[_i];
              new_cell = $('<td class="jTable-cell"></td>');
              new_cell.addClass(column.columnClass);
              new_cell.attr({
                'data-jTable-cell-attribute': column.attribute,
                'data-jTable-cell-value': item[column.attribute]
              });
              if (column.dataType === 'boolean') {
                if (item[column.attribute]) {
                  new_cell.html(column.trueValue);
                } else {
                  new_cell.html(column.falseValue);
                }
              } else {
                new_cell.html(item[column.attribute]);
              }
              new_row.append(new_cell);
            }
            if (this.settings.editLink || this.settings.destroyLink) {
              actions_cell = $('<td class="jTable-actions-cell jTable-cell"></td>');
              if (this.settings.editLink) {
                edit_link = $("<a>Edit</a>");
                edit_link.attr('href', this.settings.editUrl.replace(/\:identifier/, item[this.settings.identifierAttribute]));
                actions_cell.append(edit_link);
              }
              if (this.settings.destroyLink) {
                destroy_link = $("<a href='#'>Destroy</a>");
                destroy_link.attr('data-jTable-destroy-url', this.settings.destroyUrl.replace(/\:identifier/, item[this.settings.identifierAttribute]));
                destroy_link.click(__bind(function(event) {
                  $.ajax({
                    url: $(event.currentTarget).attr('data-jTable-destroy-url'),
                    type: 'POST',
                    data: {
                      '_method': 'DELETE'
                    },
                    success: __bind(function(data, status, xhr) {
                      return this.settings.onDestroy(data);
                    }, this),
                    error: __bind(function(xhr, status, error) {
                      return element.trigger('ajax:error', [xhr, status, error]);
                    }, this)
                  });
                  return fetchItems();
                }, this));
                actions_cell.append(destroy_link);
              }
              new_row.append(actions_cell);
            }
            _results.push(table_body.append(new_row));
          }
          return _results;
        }
      }, this);
      buildSearch = __bind(function() {
        var search_container, search_field;
        $('.jTable-full-search-container.', this.container).remove();
        search_field = $('<input type="text" />');
        search_field.keyup(__bind(function() {
          var current_search;
          this.query.search = search_field.val();
          current_search = String(this.query.search);
          return setTimeout(__bind(function() {
            if (current_search === search_field.val()) {
              this.page = 1;
              this.query.offset = 0;
              return fetchItems();
            }
          }, this), this.settings.ajaxInterval);
        }, this));
        search_container = $('<div class="jTable-full-search-container"></div>');
        search_container.html('Search: ');
        search_container.append(search_field);
        return $('.jTable-top-toolbar', this.container).prepend(search_container);
      }, this);
      buildBottomToolbar = __bind(function() {
        var toolbar;
        toolbar = $('<div class="jTable-bottom-toolbar"><div class="jTable-page-info"></div><div class="jTable-pagination-container"></div></div>');
        this.container.append(toolbar);
        updatePageInfo();
        return updatePagination();
      }, this);
      updatePageInfo = __bind(function() {
        var end_items, page_info, start_items, total_items;
        page_info = $('.jTable-page-info', this.container);
        start_items = this.items_count === 0 ? 0 : ((this.page - 1) * this.settings.perPage) + 1;
        end_items = this.items_count - start_items > this.settings.perPage ? start_items + this.settings.perPage - 1 : this.items_count;
        total_items = this.items_count;
        return page_info.html("Displaying " + start_items + " to " + end_items + " of " + total_items + " items.");
      }, this);
      updatePagination = __bind(function() {
        var end_page, generatePaginationButton, i, next_page_link, number_of_pages, page_div, page_link, prev_page_link, start_page;
        page_div = $('.jTable-pagination-container', this.container);
        page_div.html('');
        generatePaginationButton = __bind(function(page_number) {
          return $("<span class='jTable-button jTable-pagination-button' data-jTable-pagination-page='" + page_number + "'>" + page_number + "</span>").click(__bind(function(event) {
            this.stale_paging = true;
            return changePage(parseInt($(event.currentTarget).attr('data-jTable-pagination-page'), 10));
          }, this));
        }, this);
        if (!((this.page - 1) * this.settings.perPage <= 0)) {
          prev_page_link = $("<span class='jTable-button jTable-pagination-button'>Prev</span>");
          prev_page_link.click(__bind(function(event) {
            this.stale_paging = true;
            return changePage(this.page - 1);
          }, this));
          page_div.append(prev_page_link);
        }
        if (this.settings.fullPagination) {
          if (Math.ceil(this.items_count / this.settings.perPage) === 0) {
            page_link = generatePaginationButton(1);
            page_div.append(page_link);
          } else {
            number_of_pages = Math.ceil(this.items_count / this.settings.perPage);
            start_page = this.page - 2 < 1 ? 1 : this.page - 2;
            end_page = this.page + 2 > number_of_pages ? number_of_pages : this.page + 2;
            for (i = start_page; (start_page <= end_page ? i <= end_page : i >= end_page); (start_page <= end_page ? i += 1 : i -= 1)) {
              page_link = generatePaginationButton(i);
              page_div.append(page_link);
            }
          }
        }
        if (!(this.items_count <= this.page * this.settings.perPage)) {
          next_page_link = $("<span class='jTable-button jTable-pagination-button'>Next</span>");
          next_page_link.click(__bind(function(event) {
            this.stale_paging = true;
            return changePage(this.page + 1);
          }, this));
          page_div.append(next_page_link);
        }
        return $(".jTable-pagination-button[data-jTable-pagination-page=" + this.page + "]", this.container).addClass('jTable-pagination-current-page');
      }, this);
      changePage = __bind(function(new_page) {
        var i;
        if (this.settings.serverSidePagination) {
          if (this.initial_load) {
            this.page = new_page;
            updatePageInfo();
            return updatePagination();
          } else {
            if (this.stale_paging) {
              this.query.offset = (new_page - 1) * this.settings.perPage;
              this.page = new_page;
              return fetchItems();
            } else {
              this.page = new_page;
              updatePageInfo();
              return updatePagination();
            }
          }
        } else {
          this.page = new_page;
          $('tr[data-jTable-row-index]', this.table).hide();
          i = (this.page - 1) * this.settings.perPage;
          while (i < this.page * this.settings.perPage) {
            $("tr[data-jTable-row-index='" + i + "']", this.table).show();
            i++;
          }
          updatePageInfo();
          return updatePagination();
        }
      }, this);
      this.settings = $.extend(true, {}, $.jTable.defaults.settings);
      this.query = {};
      $.extend(true, this.settings, options);
      _ref = this.settings.columns;
      for (i = 0, _len = _ref.length; i < _len; i++) {
        column = _ref[i];
        this.settings.columns[i] = $.extend(true, {}, $.jTable.defaults.column, column);
        if (this.settings.columns[i].dataType === 'boolean') {
          this.settings.columns[i].searchable = false;
        }
      }
      generateBaseQuery();
      this.container = $(this);
      if (this.settings.width !== '') {
        this.container.css({
          width: this.settings.width
        });
      }
      this.container.addClass('jTable-container');
      this.initial_load = true;
      this.stale_paging = false;
      this.items = [];
      this.items_count = 0;
      this.container.data('jTable', {});
      this.container.data('jTable').settings = this.settings;
      this.previous_query = $.extend(true, {}, this.query);
      this.table = null;
      this.page = 1;
      buildAll();
      return changePage(1);
    });
  };
})(jQuery);