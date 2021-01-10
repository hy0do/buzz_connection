const { environment } = require('@rails/webpacker')
const { VueLoaderPlugin } = require('vue-loader')
const css = require('./loaders/css')
const vue = require('./loaders/vue')

environment.loaders.append('css', css)

environment.loaders.append('vue', vue)
environment.plugins.append('VueLoaderPlugin', new VueLoaderPlugin())

module.exports = environment
