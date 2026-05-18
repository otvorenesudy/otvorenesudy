import { application } from './application';
import SearchController from './search_controller';
import ChartController from './chart_controller';
import Chart2021Controller from './chart_2021_controller';
import TableController from './table_controller';
import TabsController from './tabs_controller';
import ExternalLinksController from './external_links_controller';
import AutocompleteController from './autocomplete_controller';

application.register('search', SearchController);
application.register('chart', ChartController);
application.register('chart-2021', Chart2021Controller);
application.register('table', TableController);
application.register('tabs', TabsController);
application.register('external-links', ExternalLinksController);
application.register('autocomplete', AutocompleteController);
