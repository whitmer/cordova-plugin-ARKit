import Foundation

@objc(HWPArKitPlugin) class ArKitPlugin : CDVPlugin {
    override func pluginInitialize() {
        print("HI!")
    }
    @objc func coolMethod(_ command: CDVInvokedUrlCommand) {
        //        https://github.com/taqtile-us/cordova-plugin-geofence-firebase/blob/master/src/ios/GeofencePlugin.swift
        //    result = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: warnings.joined(separator: "\n"))
        //        let result = CDVPluginResult(status: CDVCommandStatus_OK)
        //        result!.setKeepCallbackAs();
        //        commandDelegate!.send(result, callbackId: command.callbackId)
    }
}
