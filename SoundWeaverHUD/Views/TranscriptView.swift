//
//  TranscriptView.swift
//  SoundWeaverHUD
//
//  Created by Jeremy Huang on 7/28/24.
//

import SwiftUI
import Speech
import Firebase
import FirebaseDatabase

struct TranscriptView: View {
    
    let highAmbientThreshold: CGFloat = -0.025
    
    //    private var ref: DatabaseReference = Database.database().reference().child("transcript").child("text")
    //
    //    func fetchTranscript() {
    //        ref.observe(.value) { snapshot in
    //            if let value = snapshot.value as? String {
    //                self.transcriptText = value
    //            } else {
    //                self.transcriptText = "No transcript available"
    //            }
    //        }
    //    }
    
    var body: some View {
        VStack {
            ScrollViewReader { scrollView in
                ScrollView {
                    VStack {
                        Text(DataManager.shared.currentTranscript)
                            .font(.title)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding()
                            .id(DataManager.shared.currentTranscript)
                    }
                    .onChange(of: DataManager.shared.currentTranscript) {
                        withAnimation {
                            scrollView.scrollTo(DataManager.shared.currentTranscript, anchor: .bottom)
                        }
                    }
                    .padding()
                }
                .glassBackgroundEffect()
                .frame(width: 500, height: 80)
            }
            
            if DataManager.shared.averageSoundLevel < highAmbientThreshold && DataManager.shared.currentTranscript == "" {
                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundColor(.yellow) // Set icon color to yellow
                                    .font(.system(size: 40)) // Set icon size
                    Text("Captions may be inaccurate due to high ambient sound level.")
                        .foregroundStyle(.yellow)
                }
            }
        }
    }
}


//#Preview {
//    TranscriptView()
//}
