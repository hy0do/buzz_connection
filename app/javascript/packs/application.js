import Rails from "@rails/ujs"
import "../stylesheets"
import "../javascripts"

const images = require.context('../images/', true)
const imagePath = (name) => images(name, true)

Rails.start()
