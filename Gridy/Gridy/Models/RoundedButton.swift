//
//  RoundedButton.swift
//  Gridy
//
//  Created by Peter Bradtke on 29/09/2019.
//  Copyright © 2019 Peter Bradtke. All rights reserved.
//

import Foundation
import UIKit

struct RoundedButton {
    private var button: UIButton?
    
    mutating func setButton(_ button: UIButton) {
        self.button = button
    }
    
    func rounded() {
        if let newButton = button {
            newButton.layer.cornerRadius  = 10.0
            newButton.layer.masksToBounds = true
        }
    }
}

