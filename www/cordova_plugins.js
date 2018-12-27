cordova.define('cordova/plugin_list', function(require, exports, module) {
module.exports = [
  {
    "id": "cordova-plugin-arkit.cordova-plugin-arkit",
    "file": "plugins/cordova-plugin-arkit/www/cordova-plugin-arkit.js",
    "pluginId": "cordova-plugin-arkit",
    "clobbers": [
      "cordova.plugins.arkit"
    ]
  },
  {
    "id": "cordova-plugin-ionic-webview.IonicWebView",
    "file": "plugins/cordova-plugin-ionic-webview/src/www/util.js",
    "pluginId": "cordova-plugin-ionic-webview",
    "clobbers": [
      "Ionic.WebView"
    ]
  },
  {
    "id": "cordova-plugin-ionic-webview.ios-wkwebview-exec",
    "file": "plugins/cordova-plugin-ionic-webview/src/www/ios/ios-wkwebview-exec.js",
    "pluginId": "cordova-plugin-ionic-webview",
    "clobbers": [
      "cordova.exec"
    ]
  }
];
module.exports.metadata = 
// TOP OF METADATA
{
  "cordova-plugin-whitelist": "1.3.3",
  "cordova-plugin-add-swift-support": "1.7.2",
  "cordova-plugin-arkit": "0.0.1",
  "cordova-plugin-ionic-webview": "2.3.1"
};
// BOTTOM OF METADATA
});