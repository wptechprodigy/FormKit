//
//  FormViewController.swift
//  FormsSample
//
//  Created by Chris Eidhof on 22.03.18.
//  Copyright © 2018 objc.io. All rights reserved.
//

import UIKit

class FormViewController: UITableViewController {
    
    // MARK: - Properties
    
    var sections: [Section] = []
    
    // MARK: - Initializers
    
    init(sections: [Section], title: String) {
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
