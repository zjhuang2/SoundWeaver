//
//  AwarenessView.swift
//  SoundWeaverHUD
//
//  Created by Jeremy Huang on 7/28/24.
//

import SwiftUI
import Firebase
import FirebaseDatabase

struct AwarenessView: View {
    
    // Establish Firebase connection
    var databaseRef: DatabaseReference!
    
//    var classificationState: AudioClassificationState
//    @Binding var classificationConfig: AudioClassificationConfiguration
    
    //    @State var suddenSpikeDetected = SoundLevelMonitor.shared.suddenSpikeDetected
    @State var showSoundID: Bool = false
    @State var showPromptForSoundID: Bool = false
    
    var isSensing: Bool
    
//    @State var transcriptText: String = ""
    
    var body: some View {
        VStack {
            Text("\(DataManager.shared.detectionStates)")
            HStack {
                Spacer(); Spacer(); Spacer()
                Button(action: {
                    // TODO: Connect to Scene Understanding API
                }) {
                    Image(systemName: "mountain.2.fill")
                }
            }
            
            Spacer()
            
            VStack {
                VisualizerView()
            
                if DataManager.shared.spikeDetected {
                    Button(action: {
                        showSoundID = true
                        autoHideSoundID()
                    }) {
                        Text(showSoundID ? "Recognized Sounds" : "Sound ID?")
                    }
                    .buttonStyle(.plain)
                }
                
                if showSoundID {
                    SoundClassificationView()
                }
                
//                Text("\(SoundLevelMonitor.shared.suddenSpikeDetected)")
//                if SoundLevelMonitor.shared.suddenSpikeDetected {
//                    promptSoundID()
//                    Button(action: {
//                        showSoundID = true
//                    }) {
//                        Text(showSoundID ? "Sounds like" : "Show Sound IDs?")
//                    }
//                    .buttonStyle(.plain)
//                    .onAppear {
//                        autoHideSoundID()
//                    }
////                    .glassBackgroundEffect()
//                }
//                
//                if showSoundID {
//                    SoundClassificationView(classificationState: classificationState,
//                                            classificationConfig: classificationConfig)
//                }
            }
        }
    }
    
    func autoHideSoundID() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            showSoundID = false
        }
    }
    
//    private func normalize(soundLevel: Float) -> Double {
//        let minDb: Float = -160
//        let maxDb: Float = 0
//        return Double((soundLevel - minDb) / (maxDb - minDb))
//    }
//    
//    private func stopTranscribing() {
//        SpeechRecognizer.shared.stopTranscribing()
//    }
    
//    private func backgroundForCategory(_ category: SoundLevelMonitor.SoundCategory) -> Color {
//        switch category {
//        case .quiet:
//            return .green
//        case .ambient:
//            return .blue
//        case .loud:
//            return .orange
//        case .veryLoud:
//            return .red
//        }
//    }
}

//#Preview {
//    AwarenessView()
//}
