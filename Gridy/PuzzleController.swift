
import UIKit
import Photos
//import MobileCoreServices
import AVFoundation
//import AudioToolbox

class PuzzleController: UIViewController, AVAudioPlayerDelegate {
    
    //MARK: - IBOutlets
    @IBOutlet weak var tileView: UICollectionView!
    @IBOutlet weak var puzzleBoard: UICollectionView!
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
    
    //MARK: - Variables
    var toReceive = [UIImage]()
    var tileViewImages :[UIImage]!
    var puzzleBoardImages = [UIImage]()
    var fixedImages = [UIImage(named: "Blank"), UIImage(named: "Gridy-lookup")]
    var moves: Int = 0
    var rightMoves: Int = 0
    var popUpImage = UIImage()
    var isSelected: IndexPath?
    var soundIsOn: Bool = true
    var audioPlayer: AVAudioPlayer?
    
    //MARK: - View Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tileViewImages = toReceive
        tileViewImages.shuffle()
        tileView.reloadData()
        popUpView.image = popUpImage
        popUpView.isHidden = true
        scoring(moves: moves)
        for image in fixedImages {
            if let image = image {
                tileViewImages.append(image)
            }
        }
        tileView.dragInteractionEnabled = true
        puzzleBoard.dragInteractionEnabled = true
        if puzzleBoardImages.count == 0 {
            if let blank = UIImage(named: "Blank") {
                var temp = [UIImage]()
                for _ in toReceive {
                    temp.append(blank)
                }
                puzzleBoardImages = temp
                puzzleBoard.reloadData()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //MARK: - IBActions
    @IBAction func newGameAction(_ sender: Any) { }
    
    func vibrate() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
    
    func playSound() {
        if soundIsOn == true {
            audioPlayer = AVAudioPlayer()
            let Sounds = Bundle.main.path(forResource: "Correct", ofType: "mp3")
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "my3rdSegue" {
            let vc3 = segue.destination as! GameOverController
            vc3.popUpImage = popUpImage
            vc3.rightMoves = rightMoves
            vc3.moves = moves - 1
            vc3.score = yourScore()
        }
    }
    
    
}
