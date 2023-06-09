//
//  HotspotDriver.swift
//  FormsSample
//
//  Created by waheedCodes on 09/04/2023.
//  Copyright © 2023 objc.io. All rights reserved.
//

import UIKit

class HotspotDriver {
    
    // MARK: - Properties
    
    var formViewController: FormViewController!
    var sections: [Section] = []
    var state = Hotspot() {
        didSet {
            sections[0].footerTitle = state.enabledSectionFooterTitle
            sections[1].cells[0].detailTextLabel?.text = state.password
            formViewController.reloadSectionFooters()
        }
    }
    
    // MARK: - Initializer
    
    init() {
        formViewController = FormViewController(
            sections: sections,
            title: "Personal Hotspot Settings")
    }
}
