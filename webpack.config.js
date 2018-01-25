var webpack           = require('webpack')
var ExtractTextPlugin = require('extract-text-webpack-plugin')
var path              = require('path')
var nib               = require('nib')

const phoenixHTMLPath = './deps/phoenix_html/priv/static/phoenix_html.js'

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
      'highlight.js/styles/solarized-light.css'
    ]
  },
  output: {
    path: path.join(__dirname, './priv/static/js'),
    filename: '[name].js'
  },
  devtool: 'source-map',
  module: {
    rules: [
      {test: /\.json$/, loader: 'json-loader'},
      {
        test: /\.js$/,
        loader: 'babel-loader',
        options: {
          presets: ['es2015'],
          plugins: ['transform-runtime']
        },
        include: /web\/static\/js/
      },
      {test: /\.jade$/, loader: 'pug-loader'},
      {
        test: /\.styl$/,
        loader: ExtractTextPlugin.extract({
          fallback: 'style-loader',
          use: [
            'css-loader',
            {loader: 'stylus-loader', options: {use: [nib()]}}
          ]
        })
      },
      {
        test: /\.less$/,
        loader: ExtractTextPlugin.extract({
          fallback: 'style-loader',
          use: ['css-loader', 'less-loader']
        })
      },
      {
        test: /\.css$/,
        loader: ExtractTextPlugin.extract({
          fallback: 'style-loader',
          use: ['css-loader']
        })
      },
      {
        test: /\.(png|woff|woff2|eot|ttf|svg|gif)/,
        loader: 'url-loader?limit=10000'
      },
      {
        test: /\.jpg/,
        loader: 'file-loader'
      }
    ]
  },
  resolve: {
    alias: {
      phoenix_html: path.join(__dirname, phoenixHTMLPath)
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
  ]
}
