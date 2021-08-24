const webpack = require("webpack");
const path = require("path");
const nib = require("nib");
const MiniCssExtractPlugin = require("mini-css-extract-plugin");
const CopyWebpackPlugin = require("copy-webpack-plugin");

const phoenixHTMLPath = "./deps/phoenix_html/priv/static/phoenix_html.js";

module.exports = {
  mode: process.env.NODE_ENV || "development",
  entry: {
    app: ["./lib/web/static/js/app.js", "./frontend/js/index.ts"],
    theme: "./lib/web/static/css/theme.scss",
    vendor: [
      "jquery",
      "lodash",
      "riot",
      "highlight.js",
      "highlight.js/styles/solarized-light.css",
    ],
  },
  output: {
    path: path.join(__dirname, "./priv/static/"),
    filename: "[name].js",
    clean: true,
  },
  devtool: "source-map",
  module: {
    rules: [
      {
        test: /\.tsx?$/,
        use: "ts-loader",
        exclude: /node_modules/,
      },
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
        sideEffects: true,
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
        test: /\.scss$/i,
        sideEffects: true,
        use: [
          MiniCssExtractPlugin.loader,
          "css-loader",
          "sass-loader",
          "postcss-loader",
        ],
      },
      {
        test: /\.css$/,
        sideEffects: true,
        use: [MiniCssExtractPlugin.loader, "css-loader", "postcss-loader"],
      },
      {
        test: /\.(png|gif|jpeg|jpg|woff|woff2|eot|ttf|svg)/,
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
    extensions: [".tsx", ".ts", ".js", "jsx"],
    alias: {
      phoenix_html: path.join(__dirname, phoenixHTMLPath),
    },
  },
  plugins: [
    new MiniCssExtractPlugin({ filename: "./[name].css" }),
    new CopyWebpackPlugin({
      patterns: [{ from: "./frontend/static", to: "./" }],
    }),
    new webpack.ProvidePlugin({
      $: "jquery",
      jQuery: "jquery",
      "window.jQuery": "jquery",
    }),
  ],
};
