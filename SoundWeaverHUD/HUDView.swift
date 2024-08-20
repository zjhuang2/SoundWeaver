//
//  HUDView.swift
//  SoundWeaverHUD
//
//  Created by Jeremy Huang on 7/28/24.
//

import SwiftUI
import RealityKit
import RealityKitContent
import Foundation
import Firebase
import FirebaseDatabase

struct HUDView: View {
    
    // Firebase
    private var ref: DatabaseReference = Database.database().reference().child("transcript").child("text")
    
    @State var isSensing = false
    @State var currentMode: String = "Awareness"
    
    //    var classificationState = AudioClassificationState()
    //    @State var classificationConfig = AudioClassificationConfiguration()
    
    @State var transcriptText: String = ""
    @State var nameDetected: Bool = false
    
    var body: some View {
        VStack {
            Spacer(); Spacer(); Spacer(); Spacer()
            HStack {
                Button {
                    currentMode = "Awareness"
                } label: {
                    Image(systemName: "dot.radiowaves.left.and.right")
                    //                        Text(currentMode == "Awareness" ? "Awareness (Current)" : "Awareness")
                }
                .glassBackgroundEffect()
                .tint(currentMode == "Awareness" ? Color.green : Color.gray)
                
                Button {
                    currentMode = "Action"
                } label: {
                    Image(systemName: "bolt.fill")
                    //                        Text(currentMode == "Action" ? "Action (Current)" : "Action")
                }
                .glassBackgroundEffect()
                .tint(currentMode == "Action" ? Color.green : Color.gray)
                
                Button {
                    currentMode = "Social"
                } label: {
                    Image(systemName: "bubble.left.and.text.bubble.right.fill")
                    //                        Text(currentMode == "Social" ? "Social (Current)" : "Social")
                }
                .glassBackgroundEffect()
                .tint(currentMode == "Social" ? Color.green : Color.gray)
                
                Spacer()
                
                Button {
                    isSensing.toggle()
                } label: {
                    isSensing ? Image(systemName: "mic.fill") : Image(systemName: "mic.slash.fill")
                }
                .glassBackgroundEffect()
            }
        }
        
        Spacer()
        
        VStack {
            if !isSensing {
                Text("The SoundWeaver is not sensing any sound.").font(.largeTitle)
            } else {
                VStack {
                    if DataManager.shared.currentTranscriptText.contains("Darren") {
                        Text("Someone may have called your name.").font(.title)
                    }
                }
                VStack {
                    switch currentMode {
                    case "Awareness":
                        AwarenessView(isSensing: isSensing)
                    case "Action":
                        ActionView()
                    case "Social":
                        SocialView()
                    default:
                        Text("Error - not a valid mode.")
                    }
                }
            }
        }
    }
}
        
//        VStack {
//            Spacer()
//            Spacer()
//            Spacer()
//            HStack {
//                Button {
//                    currentMode = "Awareness"
//                } label: {
//                    Text(currentMode == "Awareness" ? "Awareness (Current)" : "Awareness")
//                }
//                .glassBackgroundEffect()
//                
//                Button {
//                    currentMode = "Action"
//                } label: {
//                    Text(currentMode == "Action" ? "Action (Current)" : "Action")
//                }
//                .glassBackgroundEffect()
//                
//                Button {
//                    currentMode = "Social"
//                } label: {
//                    Text(currentMode == "Social" ? "Social (Current)" : "Social")
//                }
//                .glassBackgroundEffect()
//                
//                Spacer()
//                Button(action: {
//                    if !isSensing {
//                        // Start audio classification and speech recognition
//                        classificationState.restartDetection(config: classificationConfig)
////                        startTranscribing()
//                        SoundLevelMonitor.shared.startMonitoring()
//                        isSensing.toggle()
//                    } else {
//                        // stop audio classification and speech recognition
//                        AudioClassifier.singleton.stopSoundClassification()
////                        stopTranscribing()
//                        SoundLevelMonitor.shared.stopMonitoring()
//                        isSensing.toggle()
//                    }
//                }) {
//                    Text(isSensing ? "Stop Sensing" : "Start Sensing")
//                }
//                .glassBackgroundEffect()
//            }
//            
//            VStack {
////                Text("\(nameDetected)")
//                if nameDetected {
//                    Text("Someone may have called your name.")
//                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
//                }
//            }
//            
//            VStack {
//                if currentMode == "Awareness" {
//                    AwarenessView(classificationState: classificationState,
//                                  classificationConfig: $classificationConfig,
//                                  homeSounds: homeSounds,
//                                  workSounds: workSounds,
//                                  mtgSounds: mtgSounds,
//                                  isSensing: $isSensing)
//                } else if currentMode == "Action" {
//                    ActionView()
//                } else if currentMode == "Social" {
//                    TranscriptView(transcriptText: self.transcriptText)
//                }
//            }
//        }
//        .onAppear {
//            AudioSessionManager.shared
//            fetchTranscript()
//        }
//    }
//    
//    private func startTranscribing() {
//        SpeechRecognizer.shared.startTranscribing { text in
//            DispatchQueue.main.async {
//                self.transcriptText = text
//            }
//        }
//    }
//
//    private func stopTranscribing() {
//        SpeechRecognizer.shared.stopTranscribing()
//    }
//    
//    func fetchTranscript() {
//        ref.observe(.value) { snapshot in
//            if let value = snapshot.value as? String {
//                if value.contains("Darren") || value.contains("Derek") {
//                    self.nameDetected = true
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//                        self.nameDetected = false
//                    }
//                }
//                self.transcriptText = value
//            } else {
//                self.transcriptText = "No transcript available"
//            }
//        }
//    }
//}

//#Preview {
//    HUDView()
//}
