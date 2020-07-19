//
//  ViewController.swift
//  NewNoteLearner
//
//  Created by Geoffrey Grimaud on 7/17/18.
//  Copyright © 2017 GEI. All rights reserved.
//

import AVFoundation
import UIKit

class MainViewController : UIViewController {
    @objc var changeNoteTimer: Timer?
    @objc var playToneTimer: Timer?
    var isRunning = false
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var clefImage: UIImageView!
    @IBOutlet weak var noteImage: UIImageView!
    @objc var player: AVAudioPlayer?
    var previousNote: Note?
    @objc var note: Note?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        noteLabel.font = UIFont(name: "BravuraText", size: 42) ?? UIFont()
        noteLabel.text = ""
        NotificationCenter.default.addObserver(self, selector: #selector(self.stopTimers), name: .UIApplicationDidEnterBackground, object: nil)
    }
    
    @IBAction func startStopButtonPressed(_ sender: Any) {
        //If the timers aren't running,
        //if !((changeNoteTimer != nil) && !(playToneTimer != nil)) {
        if (!isRunning) {
            startButton.setTitle("Stop", for: .normal)
            if !((changeNoteTimer != nil) && !(playToneTimer != nil)) {
            //Time to show note noteToneDelay + .75 * # of tone repeats
            let noteLength: Double = (Double(UserDefaults.standard.integer(forKey: "toneRepeats")) * 0.75) + UserDefaults.standard.double(forKey: "noteToneDelay")
            //show a new note
            newNote([])
            //Start the timer
                changeNoteTimer = Timer.scheduledTimer(withTimeInterval: noteLength, repeats: true, block: newNote(_:))
            }
        }
        else {
            startButton.setTitle("Start", for: .normal)
            stopTimers()
        }
        isRunning = !isRunning
    }
    
    @objc func newNote(_ sender: Any) {
        //stop the player if it's playing
        if player?.isPlaying != nil {
            player?.stop()
        }
        //Set the clef
        if UserDefaults.standard.integer(forKey: "selectedClef") == 0 {
            clefImage.image = UIImage(named: "Treble-1.png")
        }
        else {
            clefImage.image = UIImage(named: "Bass-1.png")
        }
        //Create random note
        note = Note().initRandom()
        //Keep choosing random notes if we keep choosing the same note as the last note
        while (note!.fullName == previousNote?.fullName) {
            note = Note().initRandom()
        }
        previousNote = note
        //Show the image
        noteImage.image = note!.note
        //Clear the note label
        noteLabel.text = ""
        //Start the timer to play the note
        playToneTimer = Timer.scheduledTimer(timeInterval: UserDefaults.standard.double(forKey: "noteToneDelay"), target: self, selector:#selector(self.playNote(note as Any)), userInfo: note, repeats: false)
    }
    
    @objc func playNote(_ sender:Any) {
        //Get the note
        //Get the path to the sound file
//                print(note!.soundName)
//                print(Bundle.main)
//                print(Bundle.main.path(forResource: note?.soundName, ofType: "aiff", inDirectory: "Sound"))
        let soundFilePath: String? = Bundle.main.path(forResource: note?.soundName, ofType: "aiff", inDirectory: "Sound")
        let fileURL = URL(fileURLWithPath: soundFilePath!)
        let newPlayer = try? AVAudioPlayer(contentsOf: fileURL)
        player = newPlayer
        player?.numberOfLoops = UserDefaults.standard.integer(forKey: "toneRepeats")
        player?.currentTime = 0.0
        player?.volume = 1
        player?.play()
        //show the name if the user so desires
        if UserDefaults.standard.bool(forKey: "showNote") {
            noteLabel.text = note?.name
//            noteLabel.text = note!.name foot book mr brown
        }
        else {
            noteLabel.text = ""
        }
    }
    
    @objc func stopTimers() {
        if changeNoteTimer != nil {
            changeNoteTimer?.invalidate()
            changeNoteTimer = nil
        }
        if playToneTimer != nil {
            playToneTimer?.invalidate()
            playToneTimer = nil
        }
        if player?.isPlaying != nil {
            player?.stop()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        stopTimers()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwind(toMain segue: UIStoryboardSegue) {
    }
}
