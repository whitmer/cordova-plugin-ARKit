import Foundation

@objc(HWPArKitPlugin) class ArKitPlugin : CDVPlugin {

    // MARK: - Properties
    
    var callbackId: String!
    
    // MARK: - Life Cycle
    
    override func pluginInitialize() {
        print("HI!")
        
        self.webView.backgroundColor = .clear
        self.webView.isOpaque = false
    }
    
    // MARK: - Sending Data Methods
    
    @objc func coolMethod(_ command: CDVInvokedUrlCommand) {
        callbackId = command.callbackId
        sendMatrix()
    }
    
    func sendMatrix() {
        guard let result = CDVPluginResult(status: CDVCommandStatus_OK,
                                           messageAs: "1,0,0,40,0,1,0,0,0,0,1,0,0,0,0,1") else { return }
        result.setKeepCallbackAs(true)
        commandDelegate!.send(result,
                              callbackId: callbackId)
    }
}
