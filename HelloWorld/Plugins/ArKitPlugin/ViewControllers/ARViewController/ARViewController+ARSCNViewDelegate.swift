//
//  ARViewController+ARSCNViewDelegate.swift
//  HelloWorld
//
//  Created by Eugene Bokhan on 27/12/2018.
//

import ARKit

extension ARViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer,
                  updateAtTime time: TimeInterval) {
        guard let camera = sceneView.pointOfView else { return }
        let cameraTransform = camera.simdWorldTransform
        delegate?.updateNodeTransform(transfrom: cameraTransform,
                                      nodeName: "Camera")
    }
    
    // MARK: - Image detection results
    
    /// - Tag: ARImageAnchor-Visualizing
    func renderer(_ renderer: SCNSceneRenderer,
                  didAdd node: SCNNode,
                  for anchor: ARAnchor) {
        guard let _ = anchor as? ARImageAnchor,
            let qrNode = self.qrNode else { return }
        
        // Add the plane visualization to the scene.
        node.addChildNode(qrNode)
        
        let qrNodeTransform = qrNode.simdWorldTransform
        delegate?.updateNodeTransform(transfrom: qrNodeTransform,
                                      nodeName: "qrNode")
        
        DispatchQueue.main.async {
            self.statusViewController.showMessage("Detected QR marker")
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer,
                  didUpdate node: SCNNode,
                  for anchor: ARAnchor) {
        guard let _ = anchor as? ARImageAnchor,
            let qrNode = self.qrNode else { return }
        
        let qrNodeTransform = qrNode.simdWorldTransform
        delegate?.updateNodeTransform(transfrom: qrNodeTransform,
                                      nodeName: "qrNode")
        
        DispatchQueue.main.async {
            self.statusViewController.showMessage("Updated QR marker position")
        }
    }
    
}


