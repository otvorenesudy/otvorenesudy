OpenCourts.SearchViewTemplates =
  template:
    remove_list_item: _.template('
      <i class="icon-remove remove"></i>
    '),

    list_item: _.template('
      <li data-value="<%= value %>"> 
        <a href="#"><%= value %></a>
        <span class="label facet"><%= facet %></span>
      </li>
    '),

    load_more: _.template('
      <a class="btn btn-load-more" href="#">
        <i class="icon-repeat" /> Load more.
      </a>
    '),

    no_more_results: _.template('
      <div>No more results.</div>
    '),

    spinner: _.template('
      <div class="spinner"></div>
    ')
