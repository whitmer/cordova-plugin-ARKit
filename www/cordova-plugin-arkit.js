var exec = require('cordova/exec');
var pluginName = 'ArKitPlugin';

exports.setListenerForArChanges = function (success, error) {
    exec(success, error, pluginName, 'setListenerForArChanges');
};

/// Add AR View below WebView and start AR session
exports.addARView = function() {
    exec(undefined, undefined, pluginName, 'addARView');
}

/// Stop AR session and remove AR View the from veiw stack
exports.removeARView = function() {
    exec(undefined, undefined, pluginName, 'removeARView');
}

exports.reloadSession = function() {
    exec(undefined, undefined, pluginName, 'reloadSession');
}