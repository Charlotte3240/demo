const path = require('path')

module.exports = {
    entry: './src/index.ts', //程序打包入口

    output: {
        filename: 'app.js', // 最终编译文件与目录
        path: path.resolve(__dirname, 'public/dist'), //__dirname 为当前路径
        publicPath: '/dist/'

    },

    module: {
        rules:[
            {
                test: /\.tsx?$/, //自定义检测文件，ts 或tsx 才进行处理

                use: 'ts-loader', //使用自定义处理器， 用ts-loader处理ts tsx文件

                exclude: '/node_modules/' // 排除node_modules目录
            }
        ]
    },
    //配置模块如何解析
    resolve: {
        extensions : ['.tsx', '.ts', '.js'], //使用import时 如果不添加扩展名，webpack按以下扩展名顺序匹配文件
    },
}