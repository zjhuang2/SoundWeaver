//
//  SoundClassificationView.swift
//  SoundWeaverHUD
//
//  Created by Jeremy Huang on 7/28/24.
//

import SwiftUI
import Combine
import SoundAnalysis

struct SoundClassificationView: View {
    
    @State var detectionStates = DataManager.shared.detectionStates
    
//    /// The runtime state that contains information about the strength of the detected sounds.
//    var classificationState: AudioClassificationState
//    
//    /// The configuration that dictates the aspect of sound classification in Awareness Mode
//    @State var classificationConfig: AudioClassificationConfiguration
    
    /// Displays a grid of sound labels for detected sounds in Awareness Mode
    ///
    /// - Parameters:
    ///     - detections: An array of detected sounds with corresponding properties, labelName and confidence.
    static func displaySoundLabelsGrid(_ detections: [[String: Any]]) -> some View {
        return HStack {
            ForEach(0 ..< detections.count, id: \.self) { index in
                if let soundLabel = detections[index]["labelName"] as? String {
                    generateSoundLabel(label: soundLabel)
                }
            }
        }
    }
    
    /// Generate individual sound label.
    static func generateSoundLabel(label: String) -> some View {
        return VStack {
            Text("\(label)")
                .fixedSize(horizontal: false, vertical: true)
                .multilineTextAlignment(.center)
                .padding()
                .frame(height: 50)
                .glassBackgroundEffect()
        }
    }
    
    var body: some View {
        VStack {
            Text("\(detectionStates)")
//            Text("Sounds Recognized").font(.title).padding()
            SoundClassificationView.displaySoundLabelsGrid(detectionStates)
        }
    }
}

//#Preview {
//    SoundClassificationView()
//}
