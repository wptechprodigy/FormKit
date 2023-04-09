//
//  SettingsViewController.swift
//  FormsSample
//
//  Created by Chris Eidhof on 22.03.18.
//  Copyright © 2018 objc.io. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {
    
    // MARK: - Properties
    
    var sections: [Section] = []
    var toggle = UISwitch()
    var state = Hotspot() {
        didSet {
            sections[0].footerTitle = state.enabledSectionFooterTitle
            sections[1].cells[0].detailTextLabel?.text = state.password
            reloadSectionFooters()
        }
    }
    
    // MARK: - Helpers
    
    private func reloadSectionFooters() {
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
            show(passwordVC, sender: self)
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
    
    private func cell(for indexPath: IndexPath) -> FormCell {
        return sections[indexPath.section].cells[indexPath.row]
    }
    
    // MARK: - Initializers
    
    init() {
        super.init(style: .grouped)
        buildSections()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Settings"
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
    
    // MARK: - Selectors
    
    @objc func toggleChanged(_ sender: Any) {
        state.isEnabled = toggle.isOn
    }
}
