//
//  FormDriver.swift
//  FormsSample
//
//  Created by waheedCodes on 09/04/2023.
//  Copyright © 2023 objc.io. All rights reserved.
//

import UIKit

class FormDriver {
    
    // MARK: - Properties
    
    var formViewController: FormViewController!
    var sections: [Section] = []
    var strongReferences: [Any]
    var update: (Hotspot) -> Void
    var state = Hotspot() {
        didSet {
            update(state)
            formViewController.reloadSectionFooters()
        }
    }
    
    // MARK: - Initializer
    
    init(initial state: Hotspot, build: (Hotspot) -> ([Section], strongReferences: [Any], update: (Hotspot) -> Void)) {
        self.state = state
        (sections, strongReferences, update) = build(state)
        formViewController = FormViewController(
            sections: sections,
            title: "Personal Hotspot Settings")
    }
}
