//
//  PlayfieldView.swift
//  Gridy
//
//  Created by Peter Bradtke on 29/08/2019.
//  Copyright © 2019 Peter Bradtke. All rights reserved.
//
import UIKit
import Photos
//import MobileCoreServices
import AVFoundation
//import AudioToolbox

class PlayfieldView: UIViewController, AVAudioPlayerDelegate {
    
    //IBOutlets
    @IBOutlet weak var GridPickerCollectionView: UICollectionView!
    @IBOutlet weak var GridBoardCollectionView: UICollectionView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var popUpView: UIImageView!
    @IBOutlet weak var newGameButton: UIButton!
    @IBAction func switchButtonOn(_ sender: UISwitch) {
        if sender .isOn {
            soundIsOn = true
        } else {
            soundIsOn = false
        }
    }
    
    //Variables
    var toReceive = [UIImage]()
    var CVOneImages :[UIImage]!
    var CVTwoImages = [UIImage]()
    var fixedImages = [UIImage(named: "Blank"), UIImage(named: "Gridy-lookup")]
    var moves: Int = 0
    var rightMoves: Int = 0
    var popUpImage = UIImage()
    var isSelected: IndexPath?
    var soundIsOn: Bool = true
    var audioPlayer: AVAudioPlayer?
    
    //View Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CVOneImages = toReceive
        CVOneImages.shuffle()
        GridPickerCollectionView.reloadData()
        popUpView.image = popUpImage
        popUpView.isHidden = true
        scoring(moves: moves)
        for image in fixedImages {
            if let image = image {
                CVOneImages.append(image)
            }
        }
        GridPickerCollectionView.dragInteractionEnabled = true
        GridBoardCollectionView.dragInteractionEnabled = true
        if CVTwoImages.count == 0 {
            if let blank = UIImage(named: "Blank") {
                var temp = [UIImage]()
                for _ in toReceive {
                    temp.append(blank)
                }
                CVTwoImages = temp
                GridPickerCollectionView.reloadData()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //IBActions
    @IBAction func newGameAction(_ sender: Any) { }
    
    func vibrate() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
    
    func playSound() {
        if soundIsOn == true {
            audioPlayer = AVAudioPlayer()
            let soundURL = Bundle.main.url(forResource: "oookay", withExtension: "wav")
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: soundURL!)
                print("sound is playing!!")
            }
            catch {
                print (error.localizedDescription)
            }
            audioPlayer!.play()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "my3rdSegue" {
            let vc3 = segue.destination as! GameOverView
            vc3.popUpImage = popUpImage
            vc3.rightMoves = rightMoves
            vc3.moves = moves - 1
            vc3.score = yourScore()
        }
    }
    
    
}
