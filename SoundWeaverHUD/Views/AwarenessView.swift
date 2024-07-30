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
    
    var homeSounds: Set<SoundIdentifier>
    var workSounds: Set<SoundIdentifier>
    var mtgSounds: Set<SoundIdentifier>
    
    @Binding var isSensing: Bool
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    // scene understanding
                }) {
                    Text("Scene Understanding")
                }
                
            }
            Spacer()
            VStack {
                SoundClassificationView(classificationState: classificationState,
                                        classificationConfig: classificationConfig)
            }
        }
    }
    
    private func stopTranscribing() {
        SpeechRecognizer.shared.stopTranscribing()
    }
}

//#Preview {
//    AwarenessView()
//}
