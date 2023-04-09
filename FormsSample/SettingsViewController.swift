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
            print(state)
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
            footer?.textLabel?.text = tableView(tableView, titleForFooterInSection: index)
            footer?.setNeedsLayout()
        }
        
        tableView.endUpdates()
        UIView.setAnimationsEnabled(true)
    }
    
    // MARK: - Initializers
    
    init() {
        super.init(style: .grouped)
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
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)

        if indexPath.section == 0 {
            cell.textLabel?.text = "Personal Hotspot"
            cell.contentView.addSubview(toggle)
            toggle.isOn = state.isEnabled
            toggle.translatesAutoresizingMaskIntoConstraints = false
            toggle.addTarget(self, action: #selector(toggleChanged(_:)), for: .valueChanged)
            cell.contentView.addConstraints([
                toggle.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
                toggle.trailingAnchor.constraint(equalTo: cell.contentView.layoutMarginsGuide.trailingAnchor)
            ])
        } else if indexPath.section == 1 {
            cell.textLabel?.text = "Password"
            cell.detailTextLabel?.text = state.password
            cell.accessoryType = .disclosureIndicator
        } else {
            fatalError()
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if section == 0 {
            return state.isEnabled ? "Personal Hotspot Enabled" : nil
        }
        return nil
    }
    
    // MARK: - TableView Delegates
    
    override func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section != 0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            let passwordVC = PasswordViewController(password: state.password) { [unowned self] in
                self.state.password = $0
            }
            navigationController?.pushViewController(passwordVC, animated: true)
        }
    }
    
    // MARK: - Selectors
    
    @objc func toggleChanged(_ sender: Any) {
        state.isEnabled = toggle.isOn
    }
}