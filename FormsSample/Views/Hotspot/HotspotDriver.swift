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
    var toggle = UISwitch()
    var state = Hotspot() {
        didSet {
            sections[0].footerTitle = state.enabledSectionFooterTitle
            sections[1].cells[0].detailTextLabel?.text = state.password
            formViewController.reloadSectionFooters()
        }
    }
    
    // MARK: - Initializer
    
    init() {
        buildSections()
        formViewController = FormViewController(
            sections: sections,
            title: "Personal Hotspot Settings")
    }
    
    // MARK: - Selectors
    
    @objc func toggleChanged(_ sender: Any) {
        state.isEnabled = toggle.isOn
    }
    
    // MARK: - Helpers
    
    private func buildSections() {
        let toogleCell = FormCell(style: .value1, reuseIdentifier: nil)
        toogleCell.textLabel?.text = "Personal Hotspot"
        toogleCell.contentView.addSubview(toggle)
        toggle.isOn = state.isEnabled
        toggle.translatesAutoresizingMaskIntoConstraints = false
        toggle.addTarget(self, action: #selector(toggleChanged(_:)), for: .valueChanged)
        toogleCell.contentView.addConstraints([
            toggle.centerYAnchor.constraint(equalTo: toogleCell.contentView.centerYAnchor),
            toggle.trailingAnchor.constraint(equalTo: toogleCell.contentView.layoutMarginsGuide.trailingAnchor)
        ])
        
        let passwordCell = FormCell(style: .value1, reuseIdentifier: nil)
        passwordCell.textLabel?.text = "Password"
        passwordCell.detailTextLabel?.text = state.password
        passwordCell.accessoryType = .disclosureIndicator
        passwordCell.shouldHighlight = true
        
        let passwordVC = PasswordViewController(password: state.password) { [unowned self] in
            self.state.password = $0
        }
        
        passwordCell.didSelect = { [unowned self] in
            formViewController.show(passwordVC, sender: self)
        }
        
        sections = [
            Section(cells: [
                toogleCell
            ], footerTitle: state.enabledSectionFooterTitle),
            Section(cells: [
                passwordCell
            ], footerTitle: nil)
        ]
    }
}
