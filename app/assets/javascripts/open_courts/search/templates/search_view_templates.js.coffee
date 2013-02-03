OpenCourts.SearchViewTemplates =
  template:
    remove_list_item: _.template("
      <i class='remove icon-remove-sign'></i>   
    "),

    list_item: _.template("
      <li data-value='<%= value %>'> 
        <a href='#'><%= value %></a>
        <span class='facet badge'><%= facet %></span>
      </li>
    "),

    load_more: _.template('
      <a class="btn btn-load-more" href="#">
        <i class="icon-repeat"/> Load more
      </a>
    '),

    no_more_results: _.template('
      <h2 align="center" style="margin-top: 40px">No more results.</h2>
    '),

    spin: _.template('
      <div class="spin"></div>
    ')


