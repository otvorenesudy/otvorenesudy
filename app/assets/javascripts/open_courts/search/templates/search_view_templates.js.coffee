OpenCourts.SearchViewTemplates =
  template:
    remove_list_item: _.template('
      <i class="icon-remove remove"></i>
    '),

    list_item: _.template('
      <li data-value="<%= value %>"> 
        <i class="icon-plus add"></i>
        <a href="#"><%= label %></a>
        <span class="label facet"><%= facet %></span>
      </li>
    '),

    list_items_fold: _.template('
      <a href="#" class="fold muted">
        Zobraziť viac <i class="icon-caret-down"></i>
      </a>
    '),

    list_items_unfold: _.template('
      <a href="#" class="fold muted">
        Zobraziť menej <i class="icon-caret-up"></i>
      </a>
    '),

    spinner: _.template('
      <div class="spinner"></div>
    ')
