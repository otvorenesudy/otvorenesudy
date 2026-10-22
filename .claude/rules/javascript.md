---
paths:
  - "app/javascript/**"
  - "app/assets/**"
  - "config/importmap.rb"
  - "package.json"
---

# JavaScript and Styles

The browser code is plain JavaScript modules, served without a build step: Importmap (`config/importmap.rb`) maps each
import to a file in `app/javascript/` or `vendor/javascript/`, and Propshaft serves it as written. Turbo drives the
navigation, Stimulus the behavior and Bootstrap 5.3 the components; charts are Chart.js, decrees' documents pdf.js.
Styles are SCSS compiled by Dart Sass (`bin/dev` watches them).

Nothing transpiles the code, so write only what current browsers run natively: class fields, optional chaining, `??`,
dynamic `import()` and the rest of modern JavaScript, but no TypeScript, JSX or anything else that needs a compiler.

## Formatting

Prettier formats `app/javascript/**/*.js` and `app/assets/stylesheets/**/*.scss` (`.prettierrc.json`: 120 columns,
single quotes, and Prettier 3's defaults otherwise: semicolons, trailing commas, parentheses around arrow parameters).
The PostToolUse hook runs `bin/lint --fix` on each file you write; don't hand-format. `vendor/` and
`app/assets/stylesheets/vendor/` are third-party code, kept as published.

## Stimulus Controllers

- One controller per behavior, in `app/javascript/controllers/<behavior>_controller.js`. `controllers/index.js` loads
  every file there, so there is nothing to register. The file name is the identifier in the markup:
  `facet_suggest_controller.js` is `data-controller="facet-suggest"`.
- `import { Controller } from '@hotwired/stimulus'` and `export default class extends Controller`: Stimulus's
  convention, and the only default export here.
- Declare `static targets` and `static values`, with defaults in the declaration
  (`delay: { type: Number, default: 300 }`), and use them (`this.inputTarget`, `this.urlValue`); don't query the DOM or
  read `data-*` attributes by hand.
- The page renders the data a controller needs as values, through a helper (`indicators_chart_data`), instead of the
  controller fetching it on load. A request the visitor triggers uses `fetch` with an `AbortController`, so a newer
  one cancels an older one (`facet_suggest_controller.js`).
- Undo in `disconnect()` what `connect()` set up: timers, charts (`this.chart?.destroy()`), pending requests. Turbo
  restores pages from its cache, so a controller connects more than once.
- A heavy library loads only where it's used: `import()` inside the controller and `preload: false` on its pin, as
  pdf.js does in `pdf_viewer_controller.js`.
- A comment above the class says what the controller does for the visitor, in a sentence or two.

## JavaScript

- `const` by default, `let` when reassigned, never `var`; `===` and `!==` only.
- Optional chaining and `??` over manual null checks; destructuring, template literals, arrow functions for callbacks.
- `async`/`await` over `.then()` chains. Catch only what you expect (the `AbortError` of a cancelled request) and
  rethrow the rest; never swallow an error.
- Guard clauses and early returns; short methods named after what they do (`showPage`, `findAgain`).
- Code that runs on every visit listens to `turbo:load`, not `DOMContentLoaded` (`external_links.js`). A module that
  isn't a controller gets a pin in `config/importmap.rb` and an import in `application.js`.
- No inline scripts, `on*` attributes or inline styles in the views. Bootstrap's components work through their
  `data-bs-*` attributes.
- Text the visitor reads comes from the page, through `t(...)`, not from strings in the JavaScript. The cookie banner's
  translations in `cookie_consent.js` are the one exception.

## Libraries

Browser libraries are listed in `package.json` at exact versions, copied into `vendor/javascript/` by `bin/vendor` and
pinned in `config/importmap.rb`; never edit the copies. To add or update one, change `package.json`, run `npm install`
and `bin/vendor`; `bin/test` fails while the copies don't match. Use what's there before adding a library.

## Styles

- SCSS in `app/assets/stylesheets/`: components in `components/`, utilities in `utilities/`, shared values in
  `variables.scss` and `mixins.scss`. Use Bootstrap's utilities and variables before writing new rules.
- roadie inlines `mailer.scss` into the e-mails: keep it to what mail clients support.

## Tests

There are no JavaScript unit tests. A flow that needs JavaScript is a system spec with `:js` (headless Chrome) that
asserts what the visitor sees; see the `rspec` rule.

## Legacy

`app/assets/javascripts/` holds the CoffeeScript of the Rails 3.2 front end. No layout loads it: don't extend it, and
port what you need into a Stimulus controller.
