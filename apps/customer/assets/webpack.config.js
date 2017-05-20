const path = require('path');
const webpack = require('webpack');
//const ExtractTextPlugin = require('extract-text-webpack-plugin');
const CopyWebpackPlugin = require('copy-webpack-plugin');
const stopUglifyJSWarnings = new webpack.optimize.UglifyJsPlugin({
  compress: {
    warnings: false
  }
});

const ROOT_PATH = path.resolve(__dirname);

const PATHS = {
  app: path.join(__dirname, './static/js/index.js'),
  build:path.join(__dirname, '../priv/static/js')
};

const LAUNCH_COMMAND = process.env.npm_lifecycle_event;

const isProduction = LAUNCH_COMMAND === 'deploy';

process.env.BABEL_ENV = LAUNCH_COMMAND;

const productionPlugin = new webpack.DefinePlugin({
  'process.env': {
    NODE_ENV: JSON.stringify('production')
  }
});

const base = {
  entry: [
    PATHS.app
  ],
  output: {
    path: PATHS.build,
    filename: 'app.js'
  },
  module: {
      rules: [
        { test: /\.js$/, exclude: /node_modules/, use: 'babel-loader' },
        {
          test: /\.css$/,
          use: [ 'style-loader', 'css-loader' ]
        }, {
          test: /\.(eot|svg|ttf|woff|woff2)$/,
          use: 'file-loader',
        }, {
          test: /\.(jpg|png|gif)$/,
          use: [
            'file-loader',
            {
              loader: 'image-webpack-loader',
              query: {
                progressive: true,
                optimizationLevel: 7,
                interlaced: false,
                pngquant: {
                  quality: '65-90',
                  speed: 4,
                },
              },
            },
          ],
        }
      ]
    },
    resolve: {
      modules: [path.resolve(__dirname, '/static/js'), 'node_modules'],
      extensions: ['.js', '.jsx', '.css'],
      alias: {
        components: path.resolve(ROOT_PATH, 'static/js/components'),
        containers: path.resolve(ROOT_PATH, 'static/js/containers'),
        pages: path.resolve(ROOT_PATH, 'static/js/pages'),
        constants: path.resolve(ROOT_PATH, 'static/js/constants'),
        utils: path.resolve(ROOT_PATH, 'static/js/utils'),
        styles: path.resolve(ROOT_PATH, 'static/js/styles')
      }
    },
    devServer: {
      historyApiFallback: {
        index: '../lib/customer/web/templates/layout/app.html.eex'
      }
    },
    plugins: [
    new webpack.LoaderOptionsPlugin({
      debug: true
    })
    ]
  };

  const developmentConfig = {
    devtool: 'cheap-module-eval-source-map',
    plugins: []
  };

  const productionConfig = {
    devtool: 'cheap-module-source-map',
    plugins: [productionPlugin, stopUglifyJSWarnings]
  };

  module.exports = Object.assign({}, base, isProduction ? productionConfig : developmentConfig );
