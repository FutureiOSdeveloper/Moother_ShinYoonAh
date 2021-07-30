//
//  UITableView+.swift
//  Moother
//
//  Created by SHIN YOON AH on 2021/07/30.
//

import UIKit

public extension UITableView {
    func isLast(for indexPath: IndexPath) -> Bool {
        let indexOfLastSection = numberOfSections > 0 ? numberOfSections - 1 : 0
        let indexOfLastRowInLastSection = numberOfRows(inSection: indexOfLastSection) - 1

        return indexPath.section == indexOfLastSection && indexPath.row == indexOfLastRowInLastSection
    }
}
