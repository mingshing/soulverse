//
//  SummitSlider.swift
//  KonoSummit
//
//  Created by mingshing on 2022/1/17.
//

import UIKit

class SummitSlider: UISlider {
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        var bounds: CGRect = self.bounds
        bounds = bounds.insetBy(dx: -10, dy: -15)
        return bounds.contains(point)
     }
}
