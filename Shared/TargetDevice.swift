//
//  DeviceType.swift
//  WatterApp
//
//  Created by IsraelBerezin on 19/01/2023.
//

import Foundation
import SwiftUI

//based: 
enum TargetDevice {
    case nativeMac
    case iPad
    case iPhone
    case iWatch
    
    public static var currentDevice: Self {
#if os(iOS)
        var currentDeviceModel = UIDevice.current.model
#else
        var currentDeviceModel = Host.current().name
#endif
        #if targetEnvironment(macCatalyst)
        currentDeviceModel = "nativeMac"
        #elseif os(watchOS)
        currentDeviceModel = "watchOS"
        #endif
        
        if (currentDeviceModel != nil) && currentDeviceModel!.starts(with: "iPhone") {
            return .iPhone
        }
        if (currentDeviceModel != nil) && currentDeviceModel!.starts(with: "iPad") {
            return .iPad
        }
        if (currentDeviceModel != nil) && currentDeviceModel!.starts(with: "watchOS") {
            return .iWatch
        }
        return .nativeMac
    }
}

