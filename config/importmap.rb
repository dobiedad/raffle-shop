# frozen_string_literal: true

# Pin npm packages by running ./bin/importmap

pin 'application'
pin '@hotwired/turbo-rails', to: 'turbo.min.js'
pin '@hotwired/stimulus', to: 'stimulus.min.js'
pin '@hotwired/stimulus-loading', to: 'stimulus-loading.js'
pin_all_from 'app/javascript/controllers', under: 'controllers'
pin 'trix'
pin '@rails/actiontext', to: 'actiontext.esm.js'
pin 'particles.js', to: 'https://cdn.jsdelivr.net/npm/particles.js@2.0.0/particles.min.js'
pin 'wow.js', to: 'https://cdn.jsdelivr.net/npm/wowjs@1.1.3/dist/wow.min.js'
