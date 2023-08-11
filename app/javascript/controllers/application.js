import { Application } from "@hotwired/stimulus"
import Hotkeys from 'stimulus-hotkeys'
import Reveal from 'stimulus-reveal-controller'
import * as ActiveStorage from "@rails/activestorage"
ActiveStorage.start()

const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

application.register('reveal', Reveal)
application.register('hotkeys', Hotkeys)

import "../active_storage/direct_uploads";

export { application }
