import Foundation

@objc(HWPArKitPlugin) class ArKitPlugin : CDVPlugin {

    // MARK: - Properties
    
    var callbackId: String!
    var arViewController: ARViewController!
    
    // MARK: - Life Cycle
    
    override func pluginInitialize() {
        instantiateARViewController()
        setupWebView()
        setupARView()
    }
    
    // MARK: - Setup Methods
    
    func instantiateARViewController() {
        let storyboard = UIStoryboard(name: "Main",
                                      bundle: nil)
        guard let arViewController = storyboard.instantiateViewController(withIdentifier: "ARViewController") as? ARViewController else {
            fatalError("ARViewController is not set in storyboard")
        }
        self.arViewController = arViewController
        self.arViewController.delegate = self
    }
    
    func setupWebView() {
        webView.backgroundColor = .clear
        webView.isOpaque = false
    }
    
    func setupARView() {
        guard let superview = webView.superview else { return }
        superview.insertSubview(arViewController.view,
                                belowSubview: webView)
    }
    
    // MARK: - Sending Data Methods
    
    @objc func coolMethod(_ command: CDVInvokedUrlCommand) {
        callbackId = command.callbackId
    }
}
