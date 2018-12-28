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
        let cameraTransform = camera.simdTransform
        delegate?.updateCameraTransform(transfrom: cameraTransform)
    }
    
}


