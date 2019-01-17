cordova.define("cordova-plugin-arkit.cordova-plugin-arkit", function(require, exports, module) {
    var exec = require('cordova/exec');
    var PLUGIN_NAME = 'ArKitPlugin';

    exports.onCameraUpdate = function (success, error) {
        exec(success, error, PLUGIN_NAME, 'setCameraListener');
    };

    exports.onQrFounded = function (success, error) {
        exec(success, error, PLUGIN_NAME, 'setOnQrFounded');
    };
    
    /// Add AR View below WebView and start AR session
    exports.startArSession = function() {
        exec(undefined, undefined, PLUGIN_NAME, 'addARView');
    };
    
    /// Stop AR session and remove AR View the from veiw stack
    exports.stopArSession = function() {
        exec(undefined, undefined, PLUGIN_NAME, 'removeARView');
    };
               
    exports.restartArSession = function() {
        exec(undefined, undefined, PLUGIN_NAME, 'restartArSession');
    };
});
