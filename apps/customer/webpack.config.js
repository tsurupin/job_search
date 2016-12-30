const path = require('path');
const webpack = require('webpack');
const HtmlWebpackPlugin = require('html-webpack-plugin');
const CopyWebpackPlugin = require('copy-webpack-plugin');

const stopUglifyJSWarnings = new webpack.optimize.UglifyJsPlugin({
  compress: {
    warnings: false
  }
});

const ROOT_PATH = path.resolve(__dirname);

const HtmlWebpackPluginConfig = new HtmlWebpackPlugin({
  template: __dirname + '/src/index.html',
  filename: 'index.html',
  inject: 'body'
});

const PATHS = {
  app: path.join(__dirname, 'src'),
  build:path.join(__dirname, 'priv/static/js')
};

const LAUNCH_COMMAND = process.env.npm_lifecycle_event;

const isProduction = LAUNCH_COMMAND === 'production';

process.env.BABEL_ENV = LAUNCH_COMMAND;

const productionPlugin = new webpack.DefinePlugin({
  'process.env': {
    NODE_ENV: JSON.stringify('production')
  }
});

const copyWebpackPlugin = new CopyWebpackPlugin([
  { from: 'src/images', to: 'priv/static/images' }
], {
  copyUnmodified: true
});

const config = {
  entry: [
    PATHS.app
  ],
  output: {
    path: PATHS.build,
    filename: 'app.js'
  },
  module: {
      loaders: [
        { test: /\.js$/, exclude: /node_moduules/, loader: 'babel-loader' },
        { test: /\.css$/, loader: 'style!css?sourceMap&modules&localIdentName=[name]__[local]___[hash:base64:5]' },

        { test:  /\.(jpg|jpeg|png|gif)$/, loader: "url-loader?limit=100", exclude: /node_modules/ }
      ]
    },
    resolve: {
      root: path.resolve(__dirname, 'src'),
      modulesDirectories: ['node_modules'],
      extensions: ['', '.js', 'css'],
      alias: {
        components: path.resolve(ROOT_PATH, 'src/components'),
        containers: path.resolve(ROOT_PATH, 'src/containers'),
        pages: path.resolve(ROOT_PATH, 'src/pages'),
        constants: path.resolve(ROOT_PATH, 'src/constants'),
        utils: path.resolve(ROOT_PATH, 'src/utils'),
        indexDatabases: path.resolve(ROOT_PATH, 'src/indexDatabases')
      }
    },
    devServer: {
      historyApiFallback: true
    }
  };

  const developmentConfig = {
    evtool: 'cheap-module-inline-source-map',
    plugins: [HtmlWebpackPluginConfig, copyWebpackPlugin]
  };

  const productionConfig = {
    devtool: 'cheap-module-source-map',
    plugins: [HtmlWebpackPluginConfig, productionPlugin, copyWebpackPlugin, stopUglifyJSWarnings]
  };

  module.exports = Object.assign({}, base, isProduction ? productionConfig : developmentConfig );
