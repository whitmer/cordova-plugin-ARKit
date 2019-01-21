//
//  ArKitPlugin+ARViewControllerDelegate.swift
//  HelloWorld
//
//  Created by Eugene Bokhan on 27/12/2018.
//

import simd

// MARK: - Sending Data Methods

extension ArKitPlugin: ARViewControllerDelegate {
    
    /// Update virtual camera's transform matrix
    ///
    /// - Parameter transfrom: float4x4 transform matrix
    func updateNodeTransform(transfrom: simd_float4x4,
                             nodeName: String) {
        sendPositionAndQuaternion(transfrom: transfrom,
                                  nodeName: nodeName)
    }
    
    /// Send virtual camera's position and quaternion to JS
    ///
    /// - Parameter transfrom: float4x4 transform matrix
    func sendPositionAndQuaternion(transfrom: simd_float4x4,
                                   nodeName: String) {
        let position = float3(transfrom.columns.3.x,
                                    transfrom.columns.3.y,
                                    transfrom.columns.3.z)
        let positionX = position.x
        let positionY = position.y
        let positionZ = position.z
        
        let quaternion = simd_quatf(transfrom)
        let quaternionX = quaternion.vector.x
        let quaternionY = quaternion.vector.y
        let quaternionZ = quaternion.vector.z
        let quaternionW = quaternion.vector.w
        
        
        let callbackId = nodeName == "Camera" ? cameraListenerCallbackId : qrFoundedCallbackId
        
        let data = [
            "positionX": positionX,
            "positionY": positionY,
            "positionZ": positionZ,
            "quaternionX": quaternionX,
            "quaternionY": quaternionY,
            "quaternionZ": quaternionZ,
            "quaternionW": quaternionW,
        ]
        
        guard let result = CDVPluginResult(status: CDVCommandStatus_OK,
                                           messageAs: data) else { return }
        
        result.setKeepCallbackAs(true)
        commandDelegate!.send(result,
                              callbackId: callbackId)
    }
    
    /// Save Callback ID
    ///
    /// - Parameter command: cordova invoked URL command
    @objc func setCameraListener(_ command: CDVInvokedUrlCommand) {
        cameraListenerCallbackId = command.callbackId
    }
    
    @objc func setOnQrFounded(_ command: CDVInvokedUrlCommand) {
        qrFoundedCallbackId = command.callbackId
    }
}