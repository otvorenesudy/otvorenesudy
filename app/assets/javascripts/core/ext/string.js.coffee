String::pluralized   = -> @.pluralize?().localeCompare(@) == 0
String::singularized = -> @.singlarize?().localeCompare(@) == 0
