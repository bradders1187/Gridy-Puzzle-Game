//
//  GameOverController.swift
//  Gridy
//
//  Created by Peter Bradtke on 30/10/2019.
//  Copyright © 2019 Peter Bradtke. All rights reserved.
//

import UIKit
import AVFoundation

class GameOverController: UIViewController, AVAudioPlayerDelegate {
    
    //MARK: Outlets
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    @IBOutlet weak var optionsButton: UIButton!
    @IBOutlet weak var scoreListView: UIView!
    @IBOutlet weak var yourScore: UILabel!
    @IBOutlet weak var totalMoves: UILabel!
    @IBOutlet weak var wrongMoves: UILabel!
    @IBOutlet weak var correctMoves: UILabel!
    
    //MARK: Variables
    var popUpImage = UIImage()
    var rightMoves = Int()
    var moves = Int()
    var score = Int()
    var audioPlayer: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playSound()
        backgroundImageView.image = popUpImage
        correctMoves.text = "Correct Moves: \(rightMoves)"
        totalMoves.text = "Total Moves: \(moves)"
        wrongMoves.text = "Wrong Moves: \(moves - rightMoves)"
        yourScore.text = "Your Score: \(score)"
        self.visualEffectView.effect = nil
    }
    
    @IBAction func optionsButtonPressed(_ sender: UIButton) {
        UIView.animate(withDuration: 0.7) {
            self.visualEffectView.effect = UIBlurEffect(style: .regular)
            self.scoreListView.alpha = 0
            self.optionsButton.alpha = 0
            self.showAlert()
        }
    }
    // MARK: shows user details of game played.
    func showAlert() {
        let alert = UIAlertController(title: "Well done!", message: "Your Score: \(score) \nTotal Moves: \(moves) \nCorrect Moves: \(rightMoves) \nWrong Moves: \(moves - rightMoves)", preferredStyle: .alert)
      //user can choose from following actions
        alert.addAction(UIAlertAction(title: "New Game!", style: UIAlertAction.Style.default) {(action) in
            self.performSegue(withIdentifier: "newGameSegue", sender: self)
            })
      
        alert.addAction(UIAlertAction(title: "Share", style: .default) {(action) in
            self.displaySharingOptions()
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive) {(action) in
            UIView.animate(withDuration: 0.2) {
                self.visualEffectView.effect = nil
                self.scoreListView.alpha = 1
                self.optionsButton.alpha = 1
            }
        })
        self.present(alert, animated: true, completion: nil)
    }
    
    func playSound() {
               audioPlayer = AVAudioPlayer()
               let Sounds = Bundle.main.path(forResource: "Puzzle", ofType: "mp3")
               do {
                   audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: Sounds!))
                   print("sound is playing!!")
               }
               catch {
                   print (error.localizedDescription)
               }
               audioPlayer!.play()
        }
}

