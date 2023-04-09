//
//  Section.swift
//  FormsSample
//
//  Created by waheedCodes on 09/04/2023.
//  Copyright © 2023 objc.io. All rights reserved.
//

import Foundation

class Section {
    let cells: [FormCell]
    var footerTitle: String?
    
    init(cells: [FormCell], footerTitle: String? = nil) {
        self.cells = cells
        self.footerTitle = footerTitle
    }
}
