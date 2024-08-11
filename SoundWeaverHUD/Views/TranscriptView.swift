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
    @State var transcriptText: String = ""
    
    private var ref: DatabaseReference = Database.database().reference().child("transcript").child("text")
    
    func fetchTranscript() {
        ref.observe(.value) { snapshot in
            if let value = snapshot.value as? String {
                self.transcriptText = value
            } else {
                self.transcriptText = "No transcript available"
            }
        }
    }
    
    var body: some View {
        VStack {
            Spacer()
            VStack {
                Text(transcriptText)
                    .padding()
                    .multilineTextAlignment(.center)
                    .frame(height: 200)
            }
        }
        .onAppear {
            fetchTranscript()
        }
    }
}
//#Preview {
//    TranscriptView()
//}
