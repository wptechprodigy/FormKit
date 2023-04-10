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
    var observer: Observer!
    var state = Hotspot() {
        didSet {
            observer.update(state)
            formViewController.reloadSectionFooters()
        }
    }
    
    // MARK: - Initializer
    
    init(
        initial state: Hotspot,
        build: (
            Hotspot, @escaping ((inout Hotspot) -> Void) -> Void,
            _ pushViewController: @escaping (UIViewController) -> Void)
        -> ([Section], Observer)) {
            self.state = state
            let (sections, observer) = build(state, { [unowned self] f in
                f(&self.state)
            }, { [unowned self] vc in
                self.formViewController
                    .navigationController?
                    .show(
                        vc,
                        sender: self)
            })
            self.sections = sections
            self.observer = observer
            formViewController = FormViewController(
                sections: sections,
                title: "Personal Hotspot Settings")
        }
}
