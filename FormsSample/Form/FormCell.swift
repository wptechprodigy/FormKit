//
//  FormCell.swift
//  FormsSample
//
//  Created by waheedCodes on 09/04/2023.
//  Copyright © 2023 objc.io. All rights reserved.
//

import UIKit

class FormCell: UITableViewCell {
    var shouldHighlight = false
    var didSelect: (() -> Void)?
}
