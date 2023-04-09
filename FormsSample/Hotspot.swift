//
//  Hotspot.swift
//  FormsSample
//
//  Created by waheedCodes on 09/04/2023.
//  Copyright © 2023 objc.io. All rights reserved.
//

import Foundation

struct Hotspot {
    var isEnabled: Bool = true
    var password: String = "hello"
}

extension Hotspot {
    var enabledSectionTitle: String? {
        return isEnabled ? "Personal Hotspot Enabled" : nil
    }
}
