import Foundation

@objc(HWPArKitPlugin) class ArKitPlugin : CDVPlugin {
    @objc func coolMethod(_ command: CDVInvokedUrlCommand) {

        let result = CDVPluginResult(status: CDVCommandStatus_OK)
        commandDelegate!.send(result, callbackId: command.callbackId)
    }
}