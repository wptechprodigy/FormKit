//
//  FormViewController.swift
//  FormsSample
//
//  Created by Chris Eidhof on 22.03.18.
//  Copyright © 2018 objc.io. All rights reserved.
//

import UIKit

final class TargetAction {
    
    // MARK: - Properties
    
    private let execute: () -> Void
    
    // MARK: - Initializer
    
    init(_ execute: @escaping () -> Void) {
        self.execute = execute
    }
    
    // MARK: - Selectors
    
    @objc func action(_ sender: Any) {
        execute()
    }
}

struct Observer {
    var strongReferences: [Any]
    var update: (Hotspot) -> Void
}

func hotspotForm(state: Hotspot, change: @escaping ((inout Hotspot) -> Void) -> Void, pushViewController: @escaping (UIViewController) -> Void) -> ([Section], Observer) {
    var strongReferences: [Any] = []
    var updates: [(Hotspot) -> Void] = []
    
    let toogleCell = FormCell(style: .value1, reuseIdentifier: nil)
    let toggle = UISwitch()
    toogleCell.textLabel?.text = "Personal Hotspot"
    toogleCell.contentView.addSubview(toggle)
    toggle.isOn = state.isEnabled
    toggle.translatesAutoresizingMaskIntoConstraints = false
    
    let toggleTarget = TargetAction {
        change { $0.isEnabled = toggle.isOn }
    }
    strongReferences.append(toggleTarget)
    updates.append { state in
        toggle.isOn = state.isEnabled
    }
    toggle.addTarget(
        toggleTarget,
        action: #selector(TargetAction.action(_:)),
        for: .valueChanged)
    toogleCell.contentView.addConstraints([
        toggle.centerYAnchor.constraint(equalTo: toogleCell.contentView.centerYAnchor),
        toggle.trailingAnchor.constraint(equalTo: toogleCell.contentView.layoutMarginsGuide.trailingAnchor)
    ])
    
    let passwordCell = FormCell(style: .value1, reuseIdentifier: nil)
    passwordCell.textLabel?.text = "Password"
    passwordCell.detailTextLabel?.text = state.password
    passwordCell.accessoryType = .disclosureIndicator
    passwordCell.shouldHighlight = true
    
    updates.append { state in
        passwordCell.detailTextLabel?.text = state.password
    }
    
    let passwordDriver = PasswordDriver(password: state.password) { newPassword in
        change { $0.password = newPassword}
    }

    passwordCell.didSelect = {
        pushViewController(
            passwordDriver.formViewController)
    }
    
    let toggleSection = Section(
        cells: [toogleCell],
        footerTitle: state.enabledSectionFooterTitle)
    updates.append { state in
        toggleSection.footerTitle = state.enabledSectionFooterTitle
    }
    
    return (
        [toggleSection, Section(cells: [passwordCell], footerTitle: nil)],
        Observer(strongReferences: strongReferences) { state in
            for u in updates {
                u(state)
            }
        }
    )
}

class FormViewController: UITableViewController {
    
    // MARK: - Properties
    
    var sections: [Section] = []
    var firstResponder: UIResponder?
    
    // MARK: - Initializers
    
    init(sections: [Section], title: String, firstResponder: UIResponder? = nil) {
        self.firstResponder = firstResponder
        self.sections = sections
        super.init(style: .grouped)
        navigationItem.title = title
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        firstResponder?.becomeFirstResponder()
    }
    
    // MARK: - Helpers
    
    func reloadSectionFooters() {
        UIView.setAnimationsEnabled(false)
        tableView.beginUpdates()
        
        for index in sections.indices {
            let footer = tableView.footerView(forSection: index)
            footer?.textLabel?.text = tableView(
                tableView,
                titleForFooterInSection: index)
            footer?.setNeedsLayout()
        }
        
        tableView.endUpdates()
        UIView.setAnimationsEnabled(true)
    }
    
    private func cell(for indexPath: IndexPath) -> FormCell {
        return sections[indexPath.section].cells[indexPath.row]
    }
    
    // MARK: - TableView DataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].cells.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cell(for: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return sections[section].footerTitle
    }
    
    // MARK: - TableView Delegates
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return cell(for: indexPath).shouldHighlight
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cell(for: indexPath).didSelect?()
    }
}
