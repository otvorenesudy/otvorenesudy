---
name: Ruby
description: Instructions for general coding practices in Ruby and Ruby on Rails. Apply these rules anytime when you're writing or reviewing Ruby or Ruby on Rails code.
applyTo: "**/*.rb, **/*.rake"
---

# Copilot Ruby and Ruby on Rails Coding Style

Use this skill whenever generating Ruby or Ruby on Rails code.

## General Ruby & Formatting

- Ruby 3.3, Rails 7.1, standard OOP style.
- Use snake_case for variables/methods and CamelCase for classes/modules.
- Two-space indentation, no tabs (configured in `.streerc`).
- Line width: 120 characters (configured in `.streerc`).
- Prefer single quotes for strings unless interpolation or special escaping is required.
- **Avoid inline comments** in application code. Only use comments in very complex or non-obvious places, or for TODO comments for edge cases that are not yet covered.
- Keep methods short and focused. Extract private helpers instead of deeply nested conditionals.
- Use newlines to visually and semantically separate parts of code.
- Use early returns (`return head 404 unless ...`) to simplify branching.
- Use nested modules and plain Ruby classes.
- Use constants for large static mappings.
- Use `class << self` with `private` for internal helpers.
- Use pure functions and simple data structures (hashes, arrays) where possible.
- Use meaningful, intention-revealing names for classes, modules, methods, and variables.
- Apply the Single Responsibility Principle to classes, modules, and methods; prefer composition over inheritance where it keeps responsibilities clear.
- Use `presence`, `blank?`, and ActiveSupport helpers idiomatically, but only if ActiveSupport is included in the Gemfile or loaded externally.
- When mapping values or unifying values, prefer Ruby constructs such as `.uniq { }`, `.map { }` or similar over loops with intermediate variables. Examples:

```
# Bad
seen = {}

values.each do |e|
  seen[e.name] = { name: e.name, description: e.description }
end

seen.values

# Good
values.map { |e|  { name: e.name, description: e.description }.uniq { e[:name] } }
```

- Prefer class methods within classes/modules which do not need to store any state, also for their helper methods, make them private on class scope.

```
class DataProvider
  self.provide
    # TODO
  end

  class << self
    private 

    def private_helper_method
      # TODO
    end
  end
end
```

- **Add a blank line between logical blocks** (e.g., between conditional blocks, between method definitions, after variable assignments before control flow).
- Prefer `unless` only for negative conditions without `else`; use positive conditions with `if` when an `else` branch is needed.
- Avoid deeply nested conditionals; prefer guard clauses and small extracted methods.
- Use safe navigation (`&.`) instead of multiple `nil` checks when it improves readability.
- Prefer `.present?`, `.blank?`, `.any?`, and related predicates over manual `nil`/empty checks.
- Prefer enums and typed attributes for better model clarity and validations.
- Avoid using `puts` for debugging — use `byebug`, `pry`, or logger utilities.
- Use `Rails.cache` to store expensive computations or frequently accessed data.
- Construct file paths with `Rails.root.join(...)` instead of hardcoding.
- Use Rails generators to scaffold resources consistently.
- Always format code using `syntax_tree` by running:
  ```bash
  bundle exec syntax_tree format --write <files or directories>
  ```

  Or format changed files only:
  
  ```bash
  git diff --name-only HEAD~1 | xargs stree write --config .streerc
  ```

  RuboCop's style guide can be used as a general reference for idiomatic Ruby and Rails style, but syntax_tree is the canonical formatter for this project.


## Controllers

Follow thin-controller pattern; move business logic into services or models.

Example: OfficesController index and strong params

```ruby
class OfficesController < ApplicationController
  layout false, only: [:decrees]

  def index
    @search = OfficeSearch.new(index_params)

    ...
  end

  def show
    @office = Office.find(params[:id])
    
    ...
  end

  end

  private

  helper_method :index_params, :show_params

  def index_params
    params.permit(:page, :sort, :order, :q, type: [], city: [], prosecutors_count: [], decrees_count: [], paragraph: [])
  end
end
```

When generating new controllers:

- Inherit from `ApplicationController`.
- Use strong params with `params.permit` grouped in private methods (`index_params`, `show_params`, etc.).
- Keep instance variable setup explicit and ordered.
- Follow RESTful conventions in routing and controller actions.
- Apply the "fat model, skinny controller" pattern thoughtfully and with clean abstractions.
- Use `before_action` callbacks sparingly; do not place business logic in callbacks.
- Use `before_action` filters to load and authorize resources when appropriate.

## ApplicationController & Locale Handling

Use `before_action` with inline block and protected/private methods.

```ruby
class ApplicationController < ActionController::Base
  before_action { set_locale(locale_params[:l] || I18n.default_locale) }

  protected

  def default_url_options
    Rails.application.routes.default_url_options.merge(l: I18n.locale)
  end

  private

  def set_locale(value)
    I18n.locale = value
  rescue I18n::InvalidLocale
    redirect_to :root
  end

  def locale_params
    params.permit(:l)
  end
end
```

## Services and Search Objects

Use plain Ruby objects in `app/services` and the Search pattern in case of faceted-search business logic. 
Use services to provide hide business logic away from the controllers.

Extract reusable and non-trivial business logic into service objects for better testability and reusability. Prefer small, focused services over large "god" objects.

## Background Jobs

Pattern:

- Inherit from `ApplicationJob`.
- Use `queue_as :default` unless a specific queue is required.
- Implement `perform` delegating to private helpers.
- Use clear, deterministic string manipulation and ActiveRecord updates.

When generating jobs:

- Keep `perform` short; move complex logic into private methods.

## Logging

When logging in lib or service classes, follow this format:

- Prefix messages with the class/module name.
- Wrap interpolated values in square brackets.

Example pattern:

```ruby
Rails.logger.info "GenproGovSk::Prosecutors::Importer # Importing prosecutors ..."
Rails.logger.info "GenproGovSk::Prosecutors::Importer # Importing prosecutors completed in [#{time_taken_ms} ms]"
```

In case the code is pure Ruby, identify the logging class - either `LOGGER` or `App.logger`.

## ActiveRecord Models

Patterns from existing specs and models:

- Use standard Rails validations, use `validates :attribute, presence: true` instead of `validate_presence_of`, `validate_uniqueness_of`.
- Define validations with clear, specific rules.
- Use JSONB columns for structured data/
- Keep complex validation logic inside the model with clear error messages.
- Keep schema information at top in each model annotated automatically by `annotate_rb` (add when not available).
- Include concerns for cross-cutting features (e.g., `Embeddable`, `Indexable`).
- Use `belongs_to` with `optional: true` where associations can be nil.
- Validate presence and uniqueness as needed, matching existing patterns.
- Prefer value objects and hashes for flexible JSONB fields, and validate their structure inside custom validators.
- Define scopes for common queries.
- Provide instance methods for behavior.

Keep migrations database-agnostic when possible and avoid raw SQL unless necessary. Add indexes for foreign keys and frequently queried columns, and set `null: false` and `unique: true` constraints at the database level when appropriate.

Prefer query scopes or dedicated query objects for complex or reusable query logic. Use `find_each` when iterating over large datasets to reduce memory usage.

Use `class_name` and `foreign_key` options in associations when relationships are not obvious from naming.

Use `Rails.application.credentials` or environment variables for secrets and configuration, never hardcode them in models or other Ruby files.

Document only complex or non-obvious code paths in models with concise comments. When inline documentation is needed, you may use YARD-style comments, but keep them focused and minimal.

## App Structure

- Keep business logic in `app/services` using plain Ruby objects, following the patterns used in this project.
- When introducing form objects, place them in `app/forms` and keep them focused on validation and submission orchestration.
- When adding JSON serialization for APIs, prefer dedicated serializers in `app/serializers` to keep controllers and models lean.
- Place authorization logic in `app/policies` if you introduce policy objects.
- Isolate complex ActiveRecord queries in `app/queries` or service objects when they become hard to express as simple scopes.
- Put custom validators in `app/validators` and custom data types in `app/types` when you need to extend ActiveModel type behavior.
- Structure the GraphQL API by organizing schemas, queries, and mutations inside `app/graphql`.

## API Development

- Structure routes using RESTful `resources` and namespacing (for example `/api/v1/`) when exposing APIs.
- Return appropriate HTTP status codes for each response (for example 200 OK, 201 Created, 404 Not Found, 422 Unprocessable Entity).
- Return errors in a structured JSON format including error codes, messages, and details.
- Use strong parameters to sanitize and whitelist input.
- Serialize responses using `ActiveModel::Serializer` or `fast_jsonapi` for consistent output.
- Use custom serializers or presenters to decouple internal logic from response formatting.
- Avoid N+1 queries by eager loading associations with `includes` where necessary.
- Use pagination gems (e.g., `kaminari` or `pagy`) for endpoints returning large datasets.
- Rate limit and throttle sensitive endpoints using middleware or gems like `rack-attack`.
- Offload slow or non-blocking operations (such as sending emails or calling external APIs) to background jobs.
- Log relevant request or job metadata via the Rails logger to aid debugging and observability.
- Document endpoints using OpenAPI (Swagger), `rswag`, or `apipie-rails`.
- Use CORS headers (`rack-cors`) to allow cross-origin access to your API when needed.
- Ensure sensitive data is never exposed in JSON responses or error messages.

## Frontend Development

- Use `app/javascript` as the main directory for managing JavaScript packs, modules, and Stimulus controllers.
- Structure JavaScript by components or domains, not by file types, to keep things modular.
- Prefer Hotwire (Turbo, Stimulus) and unobtrusive JavaScript patterns for UI behavior.
- Use Stimulus controllers for binding behavior to HTML and managing UI logic declaratively.
- Organize styles using SCSS modules, Tailwind, or BEM conventions under `app/assets/stylesheets`.
- Keep view templates focused and extract repetitive markup into partials or view components.
- Use semantic HTML and follow accessibility best practices.
- Avoid inline JavaScript and inline styles; keep behavior in `.js` files and styles in stylesheets.
- Use `data-*` attributes to connect HTML to Stimulus controllers and other frontend behavior.
- Optimize assets via the asset pipeline or bundler configuration and prefer the helpers provided by Rails for asset paths.
- Use environment-specific asset loading to prevent unnecessary scripts or styles in production.
- Follow a design system or component library to keep UI consistent and scalable.
- Optimize time-to-first-paint and asset loading using lazy loading, Turbo Frames, and deferring JS.
- Test frontend functionality using system tests (Capybara) or integration tests with tools like Cypress or Playwright.

## Commands

- Use `rails generate` to create new models, controllers, and migrations.
- Use `rails db:migrate` to apply database migrations.
- Use `rails db:seed` to populate the database with initial data.
- Use `rails db:rollback` to revert the last migration.
- Use `rails console` to interact with the Rails application in a REPL environment.
- Use `rails server` to start the development server.
- Use `rails test` to run the test suite.
- Use `rails routes` to list all defined routes in the application.
- Use `rails assets:precompile` to compile assets for production.

## Testing

- Always write tests for new functionality and bug fixes, following the patterns in this repository.
- Use RSpec with `FactoryBot` and the guidelines in `rspec.instructions.md` for organizing and structuring specs.
- Prefer fast, deterministic tests; stub or mock external services instead of calling them directly.
- Avoid hitting external APIs in tests — use `WebMock`, `VCR`, or `stub_request` to isolate test environments.
- Cover important flows through request or feature/system specs where it adds value, but keep the majority of logic in unit-level tests for models, services, and other plain Ruby objects.
- Run test coverage tools like `SimpleCov` to ensure adequate code coverage.
- Avoid `sleep` in tests; use `perform_enqueued_jobs` or `ActiveJob::TestHelper` with RSpec.
- Use database cleaning tools (`DatabaseCleaner` or `transactional_fixtures`) to maintain clean state between tests.
- Test background jobs using `have_enqueued_job` matchers.
- Use custom RSpec matchers for reusable and expressive test logic.
- Avoid brittle tests — don't rely on specific timestamps, randomized data, or order unless explicitly necessary.
- Keep tests fast, reliable, and as DRY as production code.
