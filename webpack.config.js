var webpack = require("webpack");
var path = require("path");
var nib = require("nib");
const MiniCssExtractPlugin = require("mini-css-extract-plugin");

const phoenixHTMLPath = "./deps/phoenix_html/priv/static/phoenix_html.js";

module.exports = {
  mode: process.env.NODE_ENV || "development",
  entry: {
    app: "./lib/web/static/js/app.js",
    theme: "./lib/web/static/css/theme.less",
    vendor: [
      "jquery",
      "lodash",
      "riot",
      "highlight.js",
      "bootstrap",
      "font-awesome/css/font-awesome.css",
      "highlight.js/styles/solarized-light.css",
    ],
  },
  output: {
    path: path.join(__dirname, "./priv/static/js"),
    filename: "[name].js",
  },
  devtool: "source-map",
  module: {
    rules: [
      {
        test: /\.m?js$/,
        include: /web\/static\/js/,
        exclude: /(node_modules|bower_components)/,
        use: {
          loader: "babel-loader",
          options: {
            presets: ["@babel/preset-env"],
          },
        },
      },
      {
        test: /\.jade$/,
        use: [
          {
            loader: "simple-pug-loader",
          },
        ],
      },
      {
        test: /\.styl$/,
        use: [
          MiniCssExtractPlugin.loader,
          "css-loader",
          {
            loader: "stylus-loader",
            options: { stylusOptions: { use: [nib()] } },
          },
        ],
      },
      {
        test: /\.less$/i,
        use: [MiniCssExtractPlugin.loader, "css-loader", "less-loader"],
      },
      {
        test: /\.css$/,
        use: [MiniCssExtractPlugin.loader, "css-loader"],
      },
      {
        test: /\.(png|woff|woff2|eot|ttf|svg|gif)/,
        loader: "url-loader",
        options: {
          limit: 8192,
        },
      },
      {
        test: /\.jpg/,
        loader: "file-loader",
      },
    ],
  },
  resolve: {
    alias: {
      phoenix_html: path.join(__dirname, phoenixHTMLPath),
    },
  },
  plugins: [
    new MiniCssExtractPlugin(),
    new webpack.ProvidePlugin({
      $: "jquery",
      jQuery: "jquery",
      "window.jQuery": "jquery",
    }),
  ],
};
