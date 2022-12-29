const path = require('path');

module.exports = {
  context: __dirname,
  entry: [
    './app/assets/js/main.js'
  ],
  output: {
    path: path.resolve(__dirname, 'public/dist'),
    filename: 'main.min.js',
  },
  module: {
    rules: [
      {
        test: /\.s[ac]ss$/i,
        exclude: /node_modules/,
        use: [
          // Creates `style` nodes from JS strings
          "style-loader",
          // Translates CSS into CommonJS
          "css-loader",
          // Compiles Sass to CSS
          "sass-loader",
        ],
      },
    ],
  },
};
