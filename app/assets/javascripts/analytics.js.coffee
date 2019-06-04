window.ga = window.ga or ->
  (ga.q = ga.q or []).push arguments

ga.l = +new Date

ga 'create', 'UA-38636233-1', 'auto'
ga 'require', 'cleanUrlTracker', stripQuery: true, queryParamsWhitelist: ['q'], queryDimensionIndex: 1, trailingSlash: 'remove'

ga 'require', 'eventTracker', attributePrefix: 'data-', events: ['click'], hitFilter: (model, element, event) -> (
  [category, action, label] = [model.get('eventCategory'), model.get('eventAction'), model.get('eventLabel')]
  model.set('eventLabel', "#{label} value:\"#{$(element).closest('form').find('[type="search"]').val()}\"", true) if action == 'search'
  model.set('eventLabel', "#{label} value:\"#{$(element).clone().children().remove().end().text()}\"", true) if label.indexOf('facet:') >= 0
)

ga 'require', 'outboundLinkTracker', attributePrefix: 'data-', events: ['click'], hitFilter: (model, element, event) -> (
  model.set('eventCategory', 'External Link', true)
  model.set('eventAction', event.type, true)
  model.set('eventLabel', element.getAttribute('href'), true)
)

ga 'require', 'pageVisibilityTracker', fieldsObj: { eventCategory: 'Page Visibility' }, visibleThreshold: 5000, sendInitialPageview: true, pageLoadsMetricIndex: 1, visibleMetricIndex: 2
ga 'require', 'maxScrollTracker', fieldsObj: { eventCategory: 'Page Scroll' }, increaseThreshold: 10, maxScrollMetricIndex: 3
