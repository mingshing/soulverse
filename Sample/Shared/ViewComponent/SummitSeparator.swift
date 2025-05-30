//
//  SummitSeparator.swift
//  KonoSummit
//
//  Created by mingshing on 2021/9/19.
//

import UIKit

class SummitSeparator: UIView {
    
    init(color: UIColor = .basicSeparatorColor) {
        super.init(frame: .zero)
        clipsToBounds = true
        backgroundColor = color
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupView() {
        
    }
}
