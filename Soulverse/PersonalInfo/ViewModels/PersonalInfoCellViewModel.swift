//
//  PersonalInfoCellViewModel.swift
//  KonoSummit
//
//  Created by mingshing on 2022/2/19.
//

import Foundation
import UIKit

struct PersonalInfoCellViewModel {
 
    let title: String
    let isNeedSeparator: Bool
    let isHighlight: Bool
    var registerChannel: String?
    var iconName: String?
    var textColor: UIColor?
}
