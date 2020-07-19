//
//  PreferencesViewController.swift
//  NewNoteLearner
//
//  Created by Geoffrey Grimaud on 7/17/18.
//  Copyright © 2017 GEI. All rights reserved.
//
import Foundation
import UIKit

class PreferencesViewController : UIViewController {
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var showNoteNameSwitch: UISwitch!
    @IBOutlet weak var noteToneDelayLabel: UILabel!
    @IBOutlet weak var noteToneDelayStepper: UIStepper!
    @IBOutlet weak var toneRepeatsLabel: UILabel!
    @IBOutlet weak var toneRepeatsStepper: UIStepper!
    @IBOutlet weak var clefSegment: UISegmentedControl!
    @IBOutlet weak var lowNoteLabel: UILabel!
    @IBOutlet weak var lowNoteStepper: UIStepper!
    @IBOutlet weak var highNoteLabel: UILabel!
    @IBOutlet weak var highNoteStepper: UIStepper!
    @IBOutlet weak var sharpFlatSegment: UISegmentedControl!
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Update the view controls with the current preferences
        showNoteNameSwitch.isOn = UserDefaults.standard.bool(forKey: "showNote")
        noteToneDelayLabel.text = String(format: "%.1f s", UserDefaults.standard.double(forKey: "noteToneDelay"))
        noteToneDelayStepper.value = UserDefaults.standard.double(forKey: "noteToneDelay")
        toneRepeatsLabel.text = "\(UserDefaults.standard.integer(forKey: "toneRepeats"))"
        toneRepeatsStepper.value = Double(UserDefaults.standard.integer(forKey: "toneRepeats"))
        clefSegment.selectedSegmentIndex = UserDefaults.standard.integer(forKey: "selectedClef")
        //update steppers based on selected clef
        if clefSegment.selectedSegmentIndex == 0 {
            lowNoteStepper.value = UserDefaults.standard.double(forKey: "lowNoteTreble")
            highNoteStepper.value = UserDefaults.standard.double(forKey: "highNoteTreble")
            lowNoteStepper.minimumValue = 0
        }
        else {
            lowNoteStepper.value = UserDefaults.standard.double(forKey: "lowNoteBass")
            highNoteStepper.value = UserDefaults.standard.double(forKey: "highNoteBass")
            lowNoteStepper.minimumValue = 5
        }
        updateNoteLabels()
        sharpFlatSegment.selectedSegmentIndex = UserDefaults.standard.integer(forKey: "sharps")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (sender as? UIBarButtonItem) != saveButton {
            return
        }
        //Save the preferences
        UserDefaults.standard.set(showNoteNameSwitch.isOn, forKey: "showNote")
        UserDefaults.standard.set(noteToneDelayStepper.value, forKey: "noteToneDelay")
        UserDefaults.standard.set(toneRepeatsStepper.value, forKey: "toneRepeats")
        UserDefaults.standard.set(clefSegment.selectedSegmentIndex, forKey: "selectedClef")
        if clefSegment.selectedSegmentIndex == 0 {
            UserDefaults.standard.set(lowNoteStepper.value, forKey: "lowNoteTreble")
            UserDefaults.standard.set(highNoteStepper.value, forKey: "highNoteTreble")
        }
        else {
            UserDefaults.standard.set(lowNoteStepper.value, forKey: "lowNoteBass")
            UserDefaults.standard.set(highNoteStepper.value, forKey: "highNoteBass")
        }
        UserDefaults.standard.set(sharpFlatSegment.selectedSegmentIndex, forKey: "sharps")
        UserDefaults.standard.synchronize()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func noteToneDelayStepperChanged(_ sender: UIStepper) {
        noteToneDelayLabel.text = String(format: "%.1f s", sender.value)
    }
    
    @IBAction func toneDurationStepperChanged(_ sender: UIStepper) {
        toneRepeatsLabel.text = "\(Int(sender.value))"
    }
    
    @IBAction func clefSelectorChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 1 {
            lowNoteStepper.value = UserDefaults.standard.double(forKey: "lowNoteBass")
            lowNoteStepper.value = lowNoteStepper.value
            highNoteStepper.value = UserDefaults.standard.double(forKey: "highNoteBass")
            highNoteStepper.value = highNoteStepper.value
            lowNoteStepper.minimumValue = 5
        }
        else {
            lowNoteStepper.minimumValue = 0
            lowNoteStepper.value = UserDefaults.standard.double(forKey: "lowNoteTreble")
            lowNoteStepper.value = lowNoteStepper.value
            highNoteStepper.value = UserDefaults.standard.double(forKey: "highNoteTreble")
            highNoteStepper.value = highNoteStepper.value
        }
        updateNoteLabels()
    }
    
    @IBAction func lowNoteStepperChanged(_ sender: UIStepper) {
        if highNoteStepper.value <= lowNoteStepper.value {
            lowNoteStepper.value = lowNoteStepper.value - 1
        }
        updateNoteLabels()
    }
    
    @IBAction func highNoteStepperChanged(_ sender: UIStepper) {
        if lowNoteStepper.value >= highNoteStepper.value {
            highNoteStepper.value = highNoteStepper.value + 1
        }
        updateNoteLabels()
    }
    
    func updateNoteLabels() {
        lowNoteLabel.text = Note.name(forNote: Int(lowNoteStepper.value), clef: clefSegment.selectedSegmentIndex, sharpOrFlat: false)
        highNoteLabel.text = Note.name(forNote: Int(highNoteStepper.value), clef: clefSegment.selectedSegmentIndex, sharpOrFlat: false)
    }
}
