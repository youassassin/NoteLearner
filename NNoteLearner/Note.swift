//
//  Note.swift
//  NewNoteLearner
//
//  Created by Geoffrey Grimaud on 7/17/18.
//  Copyright © 2017 GEI. All rights reserved.
//
import Foundation
import UIKit

class Note {
    
    var note: UIImage?
    var name = ""
    var fullName = ""
    var soundName = ""
    
    func initNote(_ note: Int, clef: Int, sharpOrFlat: Bool) -> Note {
        
        self.note = UIImage(named: "\(Int(note))-10.png") ?? UIImage(named: "Default.png")
        name = Note.name(forNote: note, clef: clef, sharpOrFlat: sharpOrFlat)
        return self
    }
    
    /*
     Creates a new random note within the currently set preferences
     */
    func initRandom() -> Note {
        
        let clef: Int = UserDefaults.standard.integer(forKey: "selectedClef")
        var note: Int
        var sharpOrFlat: Bool = false
        //choose note based on clef
        if clef == 0 {
            let lowNote = UInt32(UserDefaults.standard.double(forKey: "lowNoteTreble"))
            let highNote = UInt32(UserDefaults.standard.double(forKey: "highNoteTreble"))
            note = Int(arc4random_uniform((highNote + 1) - lowNote) + lowNote)
        }
        else {
            let lowNote = UInt32(UserDefaults.standard.double(forKey: "lowNoteBass"))
            let highNote = UInt32(UserDefaults.standard.double(forKey: "highNoteBass"))
            note = Int(arc4random_uniform((highNote + 1) - lowNote) + lowNote)
        }
        //if sharps or flats are enabled, choose wether the note will be sharp or flat
        if UserDefaults.standard.integer(forKey: "sharps") != 2 {
            sharpOrFlat = arc4random_uniform(2) == 0
        }
        var noteFileName = "\(note + 1)"
        //If it's a sharp or flat
        if !sharpOrFlat {
            //If the user selected sharp and the note can be shar, add 'Sharp' to the end, else add 'Flat'
            if UserDefaults.standard.integer(forKey: "sharps") == 0 && Note.canBeSharp(note, clef: clef) {
                noteFileName = noteFileName + ("Sharp")
            }
            else if UserDefaults.standard.integer(forKey: "sharps") == 1 && Note.canBeFlat(note, clef: clef) {
                noteFileName = noteFileName + ("Flat")
            }
            else {
                sharpOrFlat = false
            }
        }
        //Finish the notes file name
        noteFileName = noteFileName + ("-1.png")
        self.note = UIImage(named: noteFileName) ?? UIImage(named: "Default.png")
        self.fullName = Note.fullFancyName(forNote: note, clef: clef, sharpOrFlat: sharpOrFlat)
        self.name = Note.fancyName(forNote: note, clef: clef, sharpOrFlat: sharpOrFlat)
        self.soundName = Note.name(forSoundFile: &note, clef: clef, sharpOrFlat: sharpOrFlat)
        
        return self
    }
    class func name(forSoundFile note: inout Int, clef: Int, sharpOrFlat: Bool) -> String {
        var name: String
        if sharpOrFlat && UserDefaults.standard.integer(forKey: "sharps") == 1 {
            note = note - 1
        }
        name = Note.name(forNote: note, clef: clef, sharpOrFlat: sharpOrFlat)
        if sharpOrFlat {
            name = name + ("Sharp")
        }
        if UserDefaults.standard.integer(forKey: "selectedClef") == 0 {
            name = name + ("Treble")
        }
        else {
            name = name + ("Bass")
        }
        let stringPath = Bundle.main.path(forResource: name, ofType: "aiff")
        print(stringPath)
        print(name)
        return name
    }
    
    /*
     Returns a string representing the name of 'note'. Assumes note hasn't been normalized based on the clef.
     */
    class func name(forNote note: Int, clef: Int, sharpOrFlat: Bool) -> String {
        if clef == 0 {
            return Note.name(forNoteNormalized: note, clef: clef, sharpOrFlat: sharpOrFlat)
        }
        else {
            return Note.name(forNoteNormalized: note - 5, clef: clef, sharpOrFlat: sharpOrFlat)
        }
    }
    
    /*
     Returns a string representing the name of 'note'. Assumes note has been normalized based on the clef.
     */
    class func name(forNoteNormalized note: Int, clef: Int, sharpOrFlat: Bool) -> String {
        var name: String
        if clef == 0 {
            name = Note.trebleNotes()[note]
        }
        else {
            name = Note.bassNotes()[note]
        }
        return name
    }
    
    class func fancyName(forNote note: Int, clef: Int, sharpOrFlat: Bool) -> String {
        var name: String = Note.name(forNote: note, clef: clef, sharpOrFlat: sharpOrFlat)
        //        name = (name as? NSString)?.substring(to: 1) ?? ""
        name = String(name.prefix(1))
        if sharpOrFlat {
            if UserDefaults.standard.integer(forKey: "sharps") == 0 {
                name = name + ("\u{266f}")
            }
            else {
                name = name + ("\u{266d}")
            }
        }
        return name
    }
    
    class func fullFancyName(forNote note: Int, clef: Int, sharpOrFlat: Bool) -> String {
        var name: String = Note.name(forNote: note, clef: clef, sharpOrFlat: sharpOrFlat)
        if sharpOrFlat {
            if UserDefaults.standard.integer(forKey: "sharps") == 0 {
                name = name + ("\u{266f}")
            }
            else {
                name = name + ("\u{266d}")
            }
        }
        return name
    }
//    static var trebleNotes : [String] = ["E2", "F2", "G2", "A3", "B3", "C3", "D3", "E3", "F3", "G3", "A4", "B4", "C4", "D4", "E4", "F4", "G4", "A5", "B5", "C5", "D5", "E5"]
        class func trebleNotes() -> [String] {
            var trebleNotes: [String]? = nil
            if trebleNotes == nil {
                trebleNotes = ["E2", "F2", "G2", "A3", "B3", "C3", "D3", "E3", "F3", "G3", "A4", "B4", "C4", "D4", "E4", "F4", "G4", "A5", "B5", "C5", "D5", "E5"]
            }
            return trebleNotes ?? [String]()
        }
    
//    static var bassNotes : [String] = ["E1", "F1", "G1", "A2", "B2", "C2", "D2", "E2", "F2", "G2", "A3", "B3", "C3", "D3", "E3", "F3", "G3"]
        class func bassNotes() -> [String] {
            var bassNotes: [String]? = nil
            if bassNotes == nil {
                bassNotes = ["E1", "F1", "G1", "A2", "B2", "C2", "D2", "E2", "F2", "G2", "A3", "B3", "C3", "D3", "E3", "F3", "G3"]
            }
            return bassNotes ?? [String]()
        }
    
//    static var noSharps : [String] = ["B", "E"]
        class func noSharps() -> [String] {
            return ["B", "E"]
        }
//    static var noFlats : [String] = ["C", "F"]
        class func noFlats() -> [String] {
            var noFlats: [String]? = nil
            if noFlats == nil {
                noFlats = ["C", "F"]
            }
            return noFlats ?? [String]()
        }
    
    class func canBeSharp(_ note: Int, clef: Int) -> Bool {
        var noteName: String = Note.name(forNote: note, clef: clef, sharpOrFlat: false)
        //Corner case: highest notes can't be flat
        if (noteName.isEqual("E5") && clef == 0) || (noteName.isEqual("G3") && clef == 1) {
            return false
        }
        noteName = String(noteName.prefix(1))
        return !Note.noSharps().contains(noteName)
    }
    
    class func canBeFlat(_ note: Int, clef: Int) -> Bool {
        var noteName: String = Note.name(forNote: note, clef: clef, sharpOrFlat: false)
        //Corner case: lowest Es can't be flat
        if (noteName.isEqual("E2") && clef == 0) || (noteName.isEqual("E1") && clef == 1) {
            return false
        }
        noteName = String(noteName.prefix(1))
        return !Note.noFlats().contains(noteName)
    }
}
