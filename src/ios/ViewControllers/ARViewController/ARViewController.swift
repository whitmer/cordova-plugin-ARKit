//
//  ARViewController.swift
//  HelloWorld
//
//  Created by Eugene Bokhan on 27/12/2018.
//

import ARKit
import SceneKit
import UIKit
import Vision
import simd

@objc protocol ARViewControllerDelegate: class {
    func updateNodeTransform(transfrom: simd_float4x4,
                             nodeName: String)
    
    func sendDetectedQRInfo(transfrom: simd_float4x4,
                            vumarkGUID: String)
}

class ARViewController: UIViewController {
    
    // MARK: - UI Elements
    
    @IBOutlet var sceneView: ARSCNView!
    
    @IBOutlet weak var blurView: UIVisualEffectView!
    
    /// The view controller that displays the status and "restart experience" UI.
    lazy var statusViewController: StatusViewController = {
        return children.lazy.compactMap({ $0 as? StatusViewController }).first!
    }()
    
    // MARK: - Properties
    
    /// Convenience accessor for the session owned by ARSCNView.
    var session: ARSession {
        return sceneView.session
    }
    
    /// Prevents restarting the session while a restart is in progress.
    var isRestartAvailable = true
    
    let qrNodeName = "qrNode"
    let cameraNodeName = "cameraNode"
    
    /// Delegate
    var delegate: ARViewControllerDelegate?
    
    open var vumarkGUIDs: [String] = []
    //solvePnP 60mm to meters
    open var qrImagePhysicalWidth: CGFloat = 60 / 1000
    var enableImageRecognition: Bool {
        return qrImagePhysicalWidth != 0 && !vumarkGUIDs.isEmpty
    }
    private let qrCodeGenerator = QRCodeGenerator()
    open var qrNode: SCNNode?
    
    // MARK: - View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        sceneView.session.delegate = self
        
        // Hook up status view controller callback(s).
        statusViewController.restartExperienceHandler = { [unowned self] in
            self.restartExperience()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Prevent the screen from being dimmed to avoid interuppting the AR experience.
        UIApplication.shared.isIdleTimerDisabled = true
        
        // Start the AR experience
        resetTracking()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        session.pause()
    }
    
    // MARK: - Session management
    
    /// Creates a new AR configuration to run on the `session`.
    func resetTracking() {
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        if enableImageRecognition {
            let qrImages = vumarkGUIDs.map { qrCodeGenerator.createCGImage(value: $0)! }
            var qrRefferenceImages: Set<ARReferenceImage> = []
            qrImages.forEach {
                qrRefferenceImages.insert(ARReferenceImage($0,
                                                           orientation: .up,
                                                           physicalWidth: qrImagePhysicalWidth))
            }
            configuration.detectionImages = qrRefferenceImages
        }
        
        // Run the view's session
        sceneView.session.run(configuration,
                              options: [.resetTracking, .removeExistingAnchors])
    }
}