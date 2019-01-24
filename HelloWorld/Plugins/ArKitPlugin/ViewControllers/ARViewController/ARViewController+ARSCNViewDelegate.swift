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
                                      nodeName: cameraNodeName)
    }
    
    // MARK: - Image detection results
    
    /// - Tag: ARImageAnchor-Visualizing
    func renderer(_ renderer: SCNSceneRenderer,
                  didAdd node: SCNNode,
                  for anchor: ARAnchor) {
        guard let qrNode = self.qrNode,
            delegate != nil else { return }
        
        if let _ = anchor as? ARImageAnchor {
            // Add the plane visualization to the scene.
            node.addChildNode(qrNode)
            detectQR(qrWorldTransform: qrNode.simdWorldTransform,
                     completionHandler: delegate!.sendDetectedQRInfo)
            DispatchQueue.main.async {
                self.statusViewController.showMessage("Detected QR marker")
            }
        } else if let _ = anchor as? ARObjectAnchor {
            // Add the plane visualization to the scene.
            node.addChildNode(qrNode)
            delegate!.sendDetectedQRInfo(transfrom: qrNode.simdWorldTransform,
                                         vumarkGUID: "MSFT000001")
            DispatchQueue.main.async {
                self.statusViewController.showMessage("Detected Object marker \(anchor.name ?? "")")
            }
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer,
                  didUpdate node: SCNNode,
                  for anchor: ARAnchor) {
        guard let qrNode = self.qrNode,
            delegate != nil else { return }
        
        if let _ = anchor as? ARImageAnchor {
            detectQR(qrWorldTransform: qrNode.simdWorldTransform,
                     completionHandler: delegate!.sendDetectedQRInfo)
            DispatchQueue.main.async {
                self.statusViewController.showMessage("Detected QR marker")
            }
        } else if let _ = anchor as? ARObjectAnchor {
            delegate!.sendDetectedQRInfo(transfrom: qrNode.simdWorldTransform,
                                         vumarkGUID: "MSFT000001")
            DispatchQueue.main.async {
                self.statusViewController.showMessage("Detected Object marker \(anchor.name ?? "")")
            }
        }
    }
    
}


