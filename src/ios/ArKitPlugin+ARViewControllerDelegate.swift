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
        let cameraPosition = float3(transfrom.columns.3.x,
                                    transfrom.columns.3.y,
                                    transfrom.columns.3.z)
        let cameraPositionX = cameraPosition.x
        let cameraPositionY = cameraPosition.y
        let cameraPositionZ = cameraPosition.z
        
        let cameraQuaternion = simd_quatf(transfrom)
        let cameraQuaternionX = cameraQuaternion.vector.x
        let cameraQuaternionY = cameraQuaternion.vector.y
        let cameraQuaternionZ = cameraQuaternion.vector.z
        let cameraQuaternionW = cameraQuaternion.vector.w
        
        let message = "\(nodeName): \(cameraPositionX), \(cameraPositionY), \(cameraPositionZ), \(cameraQuaternionX), \(cameraQuaternionY), \(cameraQuaternionZ), \(cameraQuaternionW)"
        
        guard let result = CDVPluginResult(status: CDVCommandStatus_OK,
                                           messageAs: message) else { return }
        result.setKeepCallbackAs(true)
        commandDelegate!.send(result,
                              callbackId: callbackId)
    }
    
    /// Save Callback ID
    ///
    /// - Parameter command: cordova invoked URL command
    @objc func setListenerForArChanges(_ command: CDVInvokedUrlCommand) {
        callbackId = command.callbackId
    }

}
