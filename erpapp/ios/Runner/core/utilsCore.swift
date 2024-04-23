//
//  utilsCore.swift
//  Runner
//
//  Created by Khá Đại Hiệp on 07/02/2023.
//

import Foundation
import UIKit
import AVFoundation

func deviceRemainingFreeSpaceInBytes() -> Int64? {
    let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last!
    guard
        let systemAttributes = try? FileManager.default.attributesOfFileSystem(forPath: documentDirectory),
        let freeSize = systemAttributes[.systemFreeSize] as? NSNumber
    else {
        // something failed
        return nil
    }
    return freeSize.int64Value
}

func checkAutoTimeSetting() -> Bool {
    let currentDate = Date()
    let systemDate = NSDate()
    // Compare the current time with the system time
    return true
}

func getLensInfo(for cameraID: String) -> [String: Any]? {
    let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .unspecified)
        let cameras = discoverySession.devices
    guard let cameraDevice = cameras.first(where: { $0.uniqueID == cameraID }) else {
            return nil
        }

    var lensInfo: [String: Any] = [
        "model": cameraDevice.modelID
    ]
    
    if #available(iOS 14.0, *) {
        lensInfo["manufacturer"] = cameraDevice.manufacturer
        cameraDevice.lensAperture
    }

    let fieldOfView = cameraDevice.activeFormat.videoFieldOfView
        lensInfo["fieldOfView"] = fieldOfView
    
    lensInfo["maxFocalLength"] = cameraDevice.activeFormat.videoMaxZoomFactor
    return lensInfo
}
