//
//  PasswordDriver.swift
//  FormsSample
//
//  Created by waheedCodes on 08/04/2023.
//  Copyright © 2023 objc.io. All rights reserved.
//

import UIKit

class PasswordDriver {
    
    // MARK: - Properties
    
    let formViewController: FormViewController!
    let textField = UITextField()
    var sections: [Section] = []
    let onChange: (String) -> ()
    
    // MARK: - Initializers
    
    init(password: String, onChange: @escaping (String) -> ()) {
        self.onChange = onChange
        textField.text = password
        formViewController = FormViewController(
            sections: sections,
            title: "Hotspot Password")
        buildSections()
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        textField.becomeFirstResponder()
//    }
    
    // MARK: - Helpers
    
    private func buildSections() {
        let cell = FormCell(style: .value1, reuseIdentifier: nil)
        cell.textLabel?.text = "Password"
        cell.contentView.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        cell.contentView.addConstraints([
            textField.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor),
            textField.trailingAnchor.constraint(equalTo: cell.contentView.layoutMarginsGuide.trailingAnchor),
            textField.leadingAnchor.constraint(equalTo: cell.textLabel!.trailingAnchor, constant: 20)
        ])
        textField.addTarget(self, action: #selector(editingEnded(_:)), for: .editingDidEnd)
        textField.addTarget(self, action: #selector(editingDidEnter(_:)), for: .editingDidEndOnExit)
        
        sections = [
            Section(cells: [cell], footerTitle: nil)
        ]
    }
    
    @objc func editingEnded(_ sender: Any) {
        onChange(textField.text ?? "")
    }
    
    @objc func editingDidEnter(_ sender: Any) {
        onChange(textField.text ?? "")
        formViewController
            .navigationController?
            .popViewController(animated: true)
    }
}
