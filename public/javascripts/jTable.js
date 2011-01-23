/* DO NOT MODIFY. This file was compiled Sun, 23 Jan 2011 00:53:49 GMT from
 * /Users/yelvert/projects/jTable/app/coffeescripts/jTable.coffee
 */

var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
(function($) {
  $.jTable = {
    defaults: {
      settings: {
        columns: [],
        identifierAttribute: 'id',
        perPage: 25,
        fullPagination: true,
        indexUrl: "",
        editLink: true,
        editUrl: "edit?id=:identifier",
        destroyLink: true,
        destroyUrl: "?id=:identifier",
        onDestroy: function() {
          return alert("Item successfully destroyed.");
        }
      },
      column: {
        searchable: true,
        sortable: true,
        dataType: 'string',
        trueValue: 'True',
        falseValue: 'False'
      }
    }
  };
  return $.fn.jTable = function(options) {
    if (options == null) {
      options = {};
    }
    return this.each(function() {
      var buildAll, buildSearch, buildTable, buildTableHead, buildTopToolbar, changePage, column, fetchItems, generateBaseQuery, i, updateItems, updatePagination, updateTableRows, _len, _ref;
      buildAll = __bind(function() {
        buildTopToolbar();
        buildTable();
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
        return this.query.searchable_columns = searchable_columns;
      }, this);
      fetchItems = __bind(function() {
        var ajax;
        return ajax = $.ajax({
          url: this.settings.indexUrl,
          data: {
            query: this.query
          },
          success: __bind(function(data, textStatus, XMLHttpRequest) {
            return updateItems(data);
          }, this)
        });
      }, this);
      updateItems = __bind(function(items) {
        var item, _i, _len;
        this.items = [];
        for (_i = 0, _len = items.length; _i < _len; _i++) {
          item = items[_i];
          this.items.push(item);
        }
        this.container.data('jTable').items = this.items;
        updateTableRows();
        this.page = 1;
        return changePage(1);
      }, this);
      buildTopToolbar = __bind(function() {
        var toolbar;
        toolbar = $('<div class="ui-toolbar ui-widget-header ui-corner-tl ui-corner-tr ui-helper-clearfix jTable-top-toolbar"></div>');
        this.container.append(toolbar);
        return buildSearch();
      }, this);
      buildTable = __bind(function() {
        this.container.append('<table class="ui-widget"><thead><tr><th></th></tr></thead><tbody></tbody></table>');
        this.table = $('table', this.element);
        return buildTableHead();
      }, this);
      buildTableHead = __bind(function() {
        var column, table_head, th, _i, _len, _ref;
        table_head = $('thead', this.table);
        _ref = this.settings.columns;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          column = _ref[_i];
          th = $('<th class="ui-state-default jTable-column-heading"></th>');
          th.attr('data-jTable-column-attribute', column.attribute);
          if (column.heading === void 0) {
            th.html("<div>" + column.attribute + "</div>");
          } else {
            th.html("<div>" + column.heading + "</div>");
          }
          if (column.sortable) {
            $('div', th).append('<span class="css_right ui-icon ui-icon-carat-2-n-s"></span>');
            th.click(column.attribute, __bind(function(event) {
              var attribute;
              $('.jTable-column-heading span').removeClass('ui-icon-triangle-1-n ui-icon-triangle-1-s');
              attribute = event.data;
              if (this.query.sort_column === attribute) {
                console.log(event.target);
                if (this.query.sort_direction === '') {
                  this.query.sort_direction = 'ASC';
                  $('span', $(event.currentTarget)).addClass('ui-icon-triangle-1-n');
                } else if (this.query.sort_direction === 'ASC') {
                  this.query.sort_direction = 'DESC';
                  $('span', $(event.currentTarget)).addClass('ui-icon-triangle-1-s');
                } else {
                  this.query.sort_column = '';
                  this.query.sort_direction = '';
                  $('span', $(event.currentTarget)).addClass('ui-icon-carat-2-n-s');
                }
              } else {
                this.query.sort_column = attribute;
                this.query.sort_direction = 'ASC';
                $('span', $(event.currentTarget)).addClass('ui-icon-triangle-1-n');
              }
              return fetchItems();
            }, this));
          }
          table_head.append($(th));
        }
        if (this.settings.editLink || this.settings.destroyLink) {
          return table_head.append($('<th class="ui-state-default jTable-column-heading">&nbsp</th>'));
        }
      }, this);
      updateTableRows = __bind(function() {
        var actions_cell, column, destroy_link, edit_link, i, item, new_cell, new_row, table_body, _i, _len, _len2, _ref, _ref2, _results;
        table_body = $('tbody', this.table);
        table_body.html('');
        _ref = this.items;
        _results = [];
        for (i = 0, _len = _ref.length; i < _len; i++) {
          item = _ref[i];
          new_row = $("<tr data-jTable-row-index='" + i + "'></tr>");
          new_row.attr('data-jTable-item-identifier', item[this.settings.identifierAttribute]);
          _ref2 = this.settings.columns;
          for (_i = 0, _len2 = _ref2.length; _i < _len2; _i++) {
            column = _ref2[_i];
            new_cell = $('<td></td>');
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
            actions_cell = $("<td></td>");
            if (this.settings.editLink) {
              edit_link = $("<a>Edit</a>");
              edit_link.attr('href', this.settings.editUrl.replace(/\:identifier/, item[this.settings.identifierAttribute]));
              actions_cell.append(edit_link);
            }
            if (this.settings.destroyLink) {
              destroy_link = $("<a href='#'}>Destroy</a>");
              destroy_link.attr('data-jTable-destroy-url', this.settings.destroyUrl.replace(/\:identifier/, item[this.settings.identifierAttribute]));
              destroy_link.click(__bind(function(event) {
                $.ajax({
                  url: $(event.target).attr('data-jTable-destroy-url'),
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
      }, this);
      buildSearch = __bind(function() {
        var search_container, search_field;
        $('.jTable-full-search-container.').remove();
        search_field = $('<input type="text" />');
        search_field.keyup(__bind(function() {
          this.query.search = search_field.val();
          return fetchItems();
        }, this));
        search_container = $('<div class="css_left jTable-full-search-container"></div>');
        search_container.html('Search: ');
        search_container.append(search_field);
        return $('.jTable-top-toolbar', this.container).prepend(search_container);
      }, this);
      updatePagination = __bind(function() {
        var i, next_page_link, page_div, page_link, prev_page_link, _ref;
        $('div.pagination-container', this.container).remove();
        page_div = $('<div class="pagination-container"></div>');
        if (!((this.page - 1) * this.settings.perPage <= 0)) {
          prev_page_link = $("<a href='#'>Prev</a>");
          prev_page_link.click(__bind(function(event) {
            return changePage(this.page - 1);
          }, this));
          page_div.append(prev_page_link);
        }
        if (this.settings.fullPagination) {
          if (Math.ceil(this.items.length / this.settings.perPage) === 0) {
            page_link = $("<a data-jTable-pagination-page='" + i + "' href='#'>" + i + "</a>");
            page_link.click(__bind(function(event) {
              var page;
              page = parseInt($(event.target).attr('data-jTable-pagination-page'), 10);
              return changePage(page);
            }, this));
            page_div.append(page_link);
          } else {
            for (i = 1, _ref = Math.ceil(this.items.length / this.settings.perPage); (1 <= _ref ? i <= _ref : i >= _ref); (1 <= _ref ? i += 1 : i -= 1)) {
              page_link = $("<a data-jTable-pagination-page='" + i + "' href='#'>" + i + "</a>");
              page_link.click(__bind(function(event) {
                var page;
                page = parseInt($(event.target).attr('data-jTable-pagination-page'), 10);
                return changePage(page);
              }, this));
              page_div.append(page_link);
            }
          }
        }
        if (!(this.items.length <= this.page * this.settings.perPage)) {
          next_page_link = $("<a href='#'>Next</a>");
          next_page_link.click(__bind(function(event) {
            return changePage(this.page + 1);
          }, this));
          page_div.append(next_page_link);
        }
        return this.container.append(page_div);
      }, this);
      changePage = __bind(function(new_page) {
        var i;
        this.page = new_page;
        $('tr[data-jTable-row-index]', this.table).hide();
        i = (this.page - 1) * this.settings.perPage;
        while (i < this.page * this.settings.perPage) {
          $("tr[data-jTable-row-index='" + i + "']", this.table).show();
          i++;
        }
        return updatePagination();
      }, this);
      this.settings = $.jTable.defaults.settings;
      this.query = {};
      $.extend(true, this.settings, options);
      _ref = this.settings.columns;
      for (i = 0, _len = _ref.length; i < _len; i++) {
        column = _ref[i];
        this.settings.columns[i] = $.extend(true, {}, $.jTable.defaults.column, column);
      }
      generateBaseQuery();
      this.container = $(this);
      this.container.addClass('ui-widget jTable-container');
      this.items = [];
      this.container.data('jTable', {});
      this.container.data('jTable').settings = this.settings;
      this.table = null;
      this.page = 1;
      buildAll();
      return changePage(1);
    });
  };
})(jQuery);