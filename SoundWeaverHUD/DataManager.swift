//
//  DataManager.swift
//  SoundWeaverHUD
//
//  Created by Jeremy Huang on 8/18/24.
//

import Foundation
import Firebase
import FirebaseDatabase

@Observable class DataManager {
    
    static var shared = DataManager()
    
    // Establish connection with Firebase real-time Database
    private var realtimeDB = Database.database().reference()
    
    /// --- MARK: DATA MAINFRAME ---
    ///
    // Detection States for the Awareness Mode
    var detectionStates: [[String: Any]] = []
    
    // Active task (sounds contained) in the Action Mode
    var currentActionModeSounds: [[String: Any]] = []
    var currentActionModeTaskName: String = ""
    
    var currentPinnedActionModeSounds: [[String: Any]] = []
    var currentGeneralActionModeSounds: [[String: Any]] = []
    
    // Current direction (for action modes)
    var currentDirection: String = ""
    
    // Current sound level
    var currentSoundLevel: [CGFloat] = []
    var averageSoundLevel: CGFloat = 0.0
    
    // If there is any spike detected
    var spikeDetected: Bool = false
    
    var currentTranscript: String = ""
    var currentTranscriptTextLine1: String = ""
    var currentTranscriptTextLine2: String = ""
    
    private var clearTimer: Timer?
    
    var emergencySoundDetected: Bool = false
    
//    var currentTranscriptText: String = ""
    
    private init() {
        observeActionModeModeSounds()
        observeCurrentActionModeTaskName()
        observeDetectionStates()
        observeDirection()
        observeSoundLevel()
        observeSpike()
        observeSegmentedCaptions()
        observeEmergencyDetection()
        observeCurrentTranscript()
        observeAvgSoundLevel()
    }
    
    func observeCurrentTranscript() {
        realtimeDB.child("currentTranscript").observe(.value, with: { snapshot in
            if let value = snapshot.value as? String {
                self.currentTranscript = value
            }
        })
    }
    
    func observeEmergencyDetection() {
        realtimeDB.child("emergencyDetected").observe(.value, with: { snapshot in
            if let value = snapshot.value as? Bool {
                self.emergencySoundDetected = value
            }
        })
    }
    
    func observeSegmentedCaptions() {
        realtimeDB.child("captionLines").observe(.value, with: { snapshot in
            guard let segmentedCaptions = snapshot.value as? [String] else {
                print("Invalid data structure.")
                return
            }
            
            if segmentedCaptions.count < 2 {
                self.currentTranscriptTextLine2 = segmentedCaptions[0]
            } else {
                self.currentTranscriptTextLine1 = segmentedCaptions[0]
                self.currentTranscriptTextLine2 = segmentedCaptions[1]
            }
            
            // reset the timer whenever new captions are received, otherwise clear the caption
            self.resetClearTimer()
        })
    }
    
    private func resetClearTimer() {
        clearTimer?.invalidate() // Invalidate the previous timer
        clearTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false) { [weak self] _ in
            // Clear the captions after 5 seconds of inactivity
            self?.currentTranscriptTextLine1 = ""
            self?.currentTranscriptTextLine2 = ""
        }
    }

    func observeActionModeModeSounds() {
        realtimeDB.child("currentActionModeSounds").observe(.value, with: { snapshot in
            guard let currentActionModeSounds = snapshot.value as? [[String: Any]] else {
                print("Invalid data structure.")
                return
            }
            
            self.currentActionModeSounds = currentActionModeSounds
            self.currentPinnedActionModeSounds = currentActionModeSounds.filter { soundDict in
                if let pinned = soundDict["pinned"] as? Bool {
                    return pinned
                }
                return false
            }
            self.currentGeneralActionModeSounds = currentActionModeSounds.filter { soundDict in
                if let pinned = soundDict["pinned"] as? Bool {
                    return !pinned
                }
                return false
            }
        })
    }
    
    func observeCurrentActionModeTaskName() {
        realtimeDB.child("currentTaskName").observe(.value, with: { snapshot in
            if let value = snapshot.value as? String {
                self.currentActionModeTaskName = value
            }
        })
    }
    
    func observeDetectionStates() {
        realtimeDB.child("detectionStates").observe(.value, with: { snapshot in
            guard let detectedSoundsArray = snapshot.value as? [[String: Any]] else {
                self.detectionStates = []
                print("No sound recognized.")
                return
            }
            self.detectionStates = detectedSoundsArray
        })
    }
    
    func observeDirection() {
        realtimeDB.child("direction").child("direction").observe(.value, with: { snapshot in
            if let value = snapshot.value as? String {
                self.currentDirection = value
            }
        })
    }
    
    func observeSoundLevel() {
        realtimeDB.child("soundLevel").child("value").observe(.value, with: { snapshot in
            if let value = snapshot.value as? [CGFloat] {
                self.currentSoundLevel = value
            }
        })
    }
    
    func observeSpike() {
        realtimeDB.child("spikeDetected").observe(.value, with: { snapshot in
            if let value = snapshot.value as? Bool {
                self.spikeDetected = value
            }
        })
    }
    
    func observeAvgSoundLevel() {
        realtimeDB.child("AverageSoundLevel").observe(.value, with: { snapshot in
            if let value = snapshot.value as? CGFloat {
                self.averageSoundLevel = value
            }
        })
    }
    
//    func observeTranscript() {
//        realtimeDB.child("transcript").child("text").observe(.value, with: { snapshot in
//            if let value = snapshot.value as? String {
//                self.currentTranscriptText = value
//            }
//        })
//    }
    
}
