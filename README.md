# node-webkit-mru
node-webkit template demonstrates the following:
- coffeescript
- jade
- reactjs
- [NeDB](https://github.com/louischatriot/nedb) (used to store application settings)

See it in action (gif made by [LICEcap](http://www.cockos.com/licecap/))
![demo](https://raw.githubusercontent.com/hamxiaoz/node-webkit-mru/master/demo.gif)

# Prerequisites
- download and install Node.js (it comes with npm)
    http://nodejs.org/
- install grunt by:
   `npm install -g grunt-cli` 
- install bower by:
    `npm install -g bower`
- (windows) install git for windows. Remember to select 'Run git from the windows command prompt' option when installing.
    http://msysgit.github.io/

# How to develop?
To develop, do the following:
- download [node-webkit binary files](https://github.com/rogerwang/node-webkit#downloads) and put in current folder
- `npm install`
- `bower install`
- write code in src folder
- build by `grunt`. It'll build js/app.js and css/app.css and that's all you need.
- click nw.exe to run the program.


# TODO
x remove node-webkit files
- use gulp
