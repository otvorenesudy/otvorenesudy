# frozen_string_literal: true

# JavaScript modules, served from app/javascript and vendor/javascript (bin/importmap pin <package> --download).
pin 'application'
pin '@hotwired/turbo-rails', to: 'turbo.min.js'
pin '@hotwired/stimulus', to: 'stimulus.min.js'
pin '@hotwired/stimulus-loading', to: 'stimulus-loading.js'
pin_all_from 'app/javascript/controllers', under: 'controllers'
pin '@popperjs/core', to: '@popperjs--core.js' # @2.11.8
pin 'bootstrap' # @5.3.8
pin 'chart.js' # @4.5.1
pin 'vanilla-cookieconsent' # @3.1.0
pin '@kurkle/color', to: '@kurkle--color.js' # @0.3.4
pin 'analytics'
pin 'cookie_consent'
pin 'external_links'
# pdf.js, imported by the pdf-viewer controller on a decree's page only; its worker is served beside them.
pin 'pdfjs-dist', preload: false # @6.4.299
pin 'pdfjs-dist/web/pdf_viewer', to: 'pdfjs-dist--web--pdf_viewer.js', preload: false # @6.4.299
