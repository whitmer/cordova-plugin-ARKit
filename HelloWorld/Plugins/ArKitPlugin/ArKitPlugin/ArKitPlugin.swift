import Foundation

@objc(HWPArKitPlugin) class ArKitPlugin : CDVPlugin {

    // MARK: - Properties
    
    /// Callback ID
    var callbackId: String!
    
    /// ARViewController
    var arViewController: ARViewController!
    
    // MARK: - Life Cycle
    
    /// Plugin init mehtod
    override func pluginInitialize() {
        setupWebView()
    }
    
    // MARK: - Setup Methods
    
    /// Make WebView transparent and non-clickable
    func setupWebView() {
        webView.backgroundColor = .clear
        webView.isOpaque = false
//        webView.isUserInteractionEnabled = false
    }
    
    // MARK: - ARView Life Cycle Management
    
    /// Init ARViewController from the Main storyboard
    func instantiateARViewController() {
        let storyboard = UIStoryboard(name: "Main",
                                      bundle: nil)
        guard let arViewController = storyboard.instantiateViewController(withIdentifier: "ARViewController") as? ARViewController else {
            fatalError("ARViewController is not set in storyboard")
        }
        self.arViewController = arViewController
        self.arViewController.delegate = self
    }

    /// Add AR View below WebView and start AR session
    @objc func addARView(_ command: CDVInvokedUrlCommand) {
        DispatchQueue.global(qos: .utility).async {
            self.instantiateARViewController()
            
            DispatchQueue.main.async {
                guard let superview = self.webView.superview else { return }
                superview.insertSubview(self.arViewController.view,
                                        belowSubview: self.webView)
            }
            
        }
    }
    
    /// Stop AR session and remove AR View the from veiw stack
    @objc func removeARView(_ command: CDVInvokedUrlCommand) {
        arViewController.view.removeFromSuperview()
        self.arViewController = nil
    }
    
    @objc func reloadSession(_ command: CDVInvokedUrlCommand) {
    }
    
    @objc func qrScanner(_ command: CDVInvokedUrlCommand) {
        for str in command.arguments {
            print(str);
        }
    }
    
}
