var webpack           = require('webpack')
var ExtractTextPlugin = require('extract-text-webpack-plugin')
var path              = require('path')
var nib               = require('nib')

module.exports = {
  entry: {
    app: './web/static/js/app.js',
    theme: './web/static/css/theme.less',
    vendor: [
      'jquery',
      'lodash',
      'riot',
      'highlight.js',
      'bootstrap',
      'font-awesome/css/font-awesome.css',
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
      {
        test: /\.js$/,
        loader: 'babel',
        query: {
          presets: ['es2015'],
          plugins: ['transform-runtime']
        },
        include: /web\/static\/js/
      },
      {test: /\.jade$/, loader: 'jade'},
      {test: /\.styl$/, loader: ExtractTextPlugin.extract('style-loader', 'css!stylus')},
      {test: /\.less$/, loader: ExtractTextPlugin.extract('style-loader', 'css!less')},
      {test: /\.css$/, loader: ExtractTextPlugin.extract('style-loader', 'css-loader')},
      {test: /\.(png|woff|woff2|eot|ttf|svg|gif)/, loader: 'url-loader?limit=10000'},
      {test: /\.jpg/, loader: 'file-loader'}
    ]
  },
  resolve: {
    alias: {
      phoenix_html: path.join(__dirname, './deps/phoenix_html/web/static/js/phoenix_html.js')
    }
  },
  plugins: [
    new ExtractTextPlugin('[name].css', {allChunks: true}),
    new webpack.optimize.CommonsChunkPlugin({
      name: 'vendor',
      minChunks: Infinity
    }),
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
