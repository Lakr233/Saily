//
//  Repository+WellKnown.swift
//
//
//  Created by Lakr Aream on 2022/1/27.
//

import Foundation

extension Repository {
    /// Some well known repo for jailbroken devices
    /// This is a simple solution to those users adding them from url only
    mutating func applyNoneFlatWellKnownRepositoryIfNeeded() {
        switch url.host {
        case "apt.procurs.us":
            if #available(iOS 16, *) {
                distribution = "1900"
            } else if #available(iOS 15, *) {
                distribution = "1800"
            } else {
                // since we are using deployment target iOS 15+ we wont be here
                distribution = "-"
            }
            component = "main"
            return
        case "apt.thebigboss.org", "apt.modmyi.com", "cydia.zodttd.com":
            distribution = "stable"
            component = "main"
            return
        case "apt.saurik.com":
            distribution = "ios/\(String(format: "%.2f", kCFCoreFoundationVersionNumber))"
            component = "main"
            return
        default:
            return
        }
    }
}
