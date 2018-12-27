cordova.define("cordova-plugin-arkit.cordova-plugin-arkit", function(require, exports, module) {
var exec = require('cordova/exec');

exports.coolMethod = function (arg0, success, error) {
    exec(success, error, 'ArKitPlugin', 'coolMethod', [arg0]);
};

});
