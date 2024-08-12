//
//  AwarenessView.swift
//  SoundWeaverHUD
//
//  Created by Jeremy Huang on 7/28/24.
//

import SwiftUI

struct AwarenessView: View {
    
    var classificationState: AudioClassificationState
    @Binding var classificationConfig: AudioClassificationConfiguration
    
    @State private var showContextActionSheet = false
    @State private var currentContext: String = "All"
    
//    @State var suddenSpikeDetected = SoundLevelMonitor.shared.suddenSpikeDetected
    @State var showSoundID: Bool = false
    
    var homeSounds: Set<SoundIdentifier>
    var workSounds: Set<SoundIdentifier>
    var mtgSounds: Set<SoundIdentifier>
    
    @Binding var isSensing: Bool
    
    var body: some View {
        VStack {
            HStack {
//                VStack {
//                    Text("Sound Level").font(.largeTitle)
////                    ProgressView(value: normalize(soundLevel: SoundLevelMonitor.shared.soundLevel))
////                        .frame(width: 400, height: 100)
////                        .padding()
//                    Text("\(SoundLevelMonitor.shared.soundLevelCategory.rawValue)")
//                        .font(.title)
//                        .padding()
//                        .background(backgroundForCategory(SoundLevelMonitor.shared.soundLevelCategory))
//                        .foregroundColor(.white)
//                        .cornerRadius(16)
//                }
                Spacer()
                Button(action: {
                    // scene understanding
                }) {
                    Text("Scene Understanding")
                }
                
            }
            Spacer()
            VStack {
                VisualizerView()
//                Text("\(SoundLevelMonitor.shared.suddenSpikeDetected)")
                if SoundLevelMonitor.shared.suddenSpikeDetected {
                    Button(action: {
                        showSoundID = true
                    }) {
                        Text(showSoundID ? "Sound IDs" : "Show Sound IDs?")
                    }
                    .buttonStyle(.plain)
                    .onAppear {
                        autoHideSoundID()
                    }
//                    .glassBackgroundEffect()
                }
                
                if showSoundID {
                    SoundClassificationView(classificationState: classificationState,
                                            classificationConfig: classificationConfig)
                }
            }
        }
    }
    
    func autoHideSoundID() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            showSoundID = false
        }
    }
    
    private func normalize(soundLevel: Float) -> Double {
        let minDb: Float = -160
        let maxDb: Float = 0
        return Double((soundLevel - minDb) / (maxDb - minDb))
    }
    
    private func stopTranscribing() {
        SpeechRecognizer.shared.stopTranscribing()
    }
    
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
