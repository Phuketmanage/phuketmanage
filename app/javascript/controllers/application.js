import { Application } from "@hotwired/stimulus"
import Hotkeys from 'stimulus-hotkeys'
import Reveal from 'stimulus-reveal-controller'

const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

application.register('reveal', Reveal)
application.register('hotkeys', Hotkeys)

export { application }
