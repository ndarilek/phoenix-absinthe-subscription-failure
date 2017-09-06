const webpack = require("webpack")

module.exports = {
  generate: {
    dir: "../priv/static",
    minify: {
      collapseBooleanAttributes: true,
      collapseWhitespace: process.env.NODE_ENV == "production",
      decodeEntities: true,
      minifyCSS: process.env.NODE_ENV == "production",
      minifyJS: process.env.NODE_ENV == "production",
      processConditionalComments: true,
      removeAttributeQuotes: false,
      removeComments: false,
      removeEmptyAttributes: true,
      removeOptionalTags: true,
      removeRedundantAttributes: true,
      removeScriptTypeAttributes: false,
      removeStyleLinkTypeAttributes: false,
      removeTagWhitespace: false,
      sortAttributes: true,
      sortClassName: true,
      trimCustomFragments: true,
      useShortDoctype: true
    }
  },
  build: {
    vendor: [
      "jquery",
      "bootstrap",
      "vue-apollo",
      "apollo-client",
      "vuex-class",
      "nuxt-class-component"
    ],
    plugins: [
      new webpack.ProvidePlugin({
        $: "jquery",
        jQuery: "jquery",
        "window.jQuery": "jquery"
      }),
    ]
  },
  /*
  ** Headers of the page
  */
  head: {
    titleTemplate: "%s - App",
    meta: [
      {charset: "utf-8"},
      {name: "viewport", content: "width=device-width, initial-scale=1"},
      {hid: "description", name: "description", content: "Project"}
    ],
    link: [
      { rel: 'icon', type: 'image/x-icon', href: '/favicon.ico' }
    ]
  },
  plugins: [
    "~/plugins/bootstrap",
    "~/plugins/vee-validate"
  ],
  modules: [
    "@nuxtjs/apollo"
  ],
  apollo: {
    networkInterfaces: {
      default: "~/apollo/network-interfaces/default"
    }
  }
}
