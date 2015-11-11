var webpack = require('webpack')
var ExtractTextPlugin = require('extract-text-webpack-plugin')
var nib = require('nib')

module.exports = {
  entry: {
    app: './web/static/js/app.js',
    theme: './web/static/css/theme.less',
    vendor: [
      'jquery',
      'lodash',
      'highlight.js',
      'bootstrap',
      'highlight.js/styles/solarized_light.css'
    ]
  },
  output: {
    path: './priv/static/js',
    filename: '[name].js'
  },
  devtool: 'source-map',
  module: {
    loaders: [
      {test: /\.json$/, loader: 'json'},
      {test: /\.js$/, loader: 'babel?optional[]=runtime', include: /web\/static\/js/},
      {test: /\.jade$/, loader: 'jade'},
      {test: /\.styl$/, loader: ExtractTextPlugin.extract('style-loader', 'css!stylus')},
      {test: /\.less$/, loader: ExtractTextPlugin.extract('style-loader', 'css!less')},
      {test: /\.css$/, loader: ExtractTextPlugin.extract('style-loader', 'css-loader')},
      {test: /\.(png|woff|woff2|eot|ttf|svg|gif)/, loader: 'url-loader?limit=10000'},
      {test: /\.jpg/, loader: 'file-loader'}
    ]
  },
  plugins: [
    new ExtractTextPlugin('[name].css', {allChunks: true}),
    new webpack.ProvidePlugin({
      $: 'jquery',
      jQuery: 'jquery',
      'window.jQuery': 'jquery'
    })
  ],
  stylus: {
    use: [nib()]
  }
}
