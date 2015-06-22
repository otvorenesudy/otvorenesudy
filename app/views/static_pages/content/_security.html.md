# <%= t '.title' %>

<%= t '.description_part_1' %>

<%= t '.description_part_2' %>

<%= t '.contact_us' %>:

<hr/>

<p class="lead centered">
  <%= mail_to 'bezpecnost@otvorenesudy.sk', nil, encode: :hex %>
</p>

<hr/>

<%= t '.we_are_thankful' %>
