var webpack = require('webpack')
var ExtractTextPlugin = require('extract-text-webpack-plugin')

module.exports = {
  entry: {
    app: './web/static/js/app.js',
    vendor: ['bootstrap', 'bootstrap/dist/css/bootstrap.css']
  },
  output: {
    path: './priv/static/js',
    filename: 'bundle.js'
  },
  devtool: 'source-map',
  module: {
    loaders: [
      {test: /\.js$/, loader: 'babel?optional[]=runtime', include: /web\/static\/js/},
      {test: /\.jade$/, loader: 'jade'},
      {test: /\.css$/, loader: ExtractTextPlugin.extract('style-loader', 'css-loader')},
      {test: /\.(png|woff|woff2|eot|ttf|svg|gif)/, loader: 'url-loader?limit=10000'},
      {test: /\.jpg/, loader: 'file-loader'}
    ]
  },
  plugins: [
    new webpack.optimize.CommonsChunkPlugin('vendor', 'vendor.bundle.js'),
    new ExtractTextPlugin('style.css')
  ]
}
