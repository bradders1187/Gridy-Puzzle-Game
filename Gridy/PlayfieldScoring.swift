//
//  PlayfieldScoring.swift
//  Gridy
//
//  Created by Peter Bradtke on 17/09/2019.
//  Copyright © 2019 Peter Bradtke. All rights reserved.
//

import UIKit

extension PlayfieldView {
    func scoring(moves: Int) {
        self.moves += 1
        scoreLabel.text = "\(moves)"
    }
    
    func yourScore() -> Int {
        let score = (moves * 100) / (moves - rightMoves)
        return score
    }
}

