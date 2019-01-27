const {
    environment
} = require('@rails/webpacker')
const erb =  require('./loaders/erb')
const coffee =  require('./loaders/coffee')

// var path = require('path');
// environment.loaders.append('fonts', {
//     test: /\.(woff(2)?|eot|otf|ttf|svg)(\?v=[0-9]\.[0-9]\.[0-9])?$/,
//     exclude: path.resolve(__dirname, '../../app/assets'),
//     use: {
//         loader: 'file-loader',
//         options: {
//             outputPath: 'fonts/',
//             useRelativePath: false
//         }
//     }
// })
// environment.loaders.append('images', {
//     test: /\.(png|jpg(eg)?|gif|ico)$/,
//     exclude: path.resolve(__dirname, '../../app/assets'),
//     use: {
//         loader: 'file-loader',
//         options: {
//             outputPath: 'images/',
//             useRelativePath: false
//         }
//     }
// })

const webpack = require('webpack');
environment.plugins.append('Provide', new webpack.ProvidePlugin({
    $: 'jquery',
    jQuery: 'jquery'
}));


environment.loaders.append('coffee', coffee)
environment.loaders.append('erb', erb)
module.exports = environment