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
    
    @State var showSoundID: Bool = false
    @State var showPromptForSoundID: Bool = false
    
    var isSensing: Bool
    
    @State var isWaitingResponse = false
    @State var APIResponse: String? = nil
    
    
    var body: some View {
        VStack {
            //            Text("\(DataManager.shared.detectionStates)")
            HStack {
                Spacer()
                Button(action: {
                    startASUTask()
                    observeAPIResponse()
                }) {
                    if isWaitingResponse {
                        ProgressView("Sensing Environment...")
                            .padding()
                    } else {
                        Image(systemName: "mountain.2.fill")
                    }
                }
            }
            VStack {
                if let response = APIResponse {
                    if response != "No response yet" {
                        Text(response)
                    }
                }
            }
            
            Spacer()
            
            VStack {
                HStack {
                    VisualizerView()
                        .padding()
                    
                    Button(action: {
                        showSoundID.toggle()
//                        autoHideSoundID()
                    }) {
                        Image(systemName: showSoundID ? "clear.fill" : "text.magnifyingglass")
                    }
                    .glassBackgroundEffect()
                }
                
                if !showSoundID && DataManager.shared.spikeDetected {
                    Button(action: {
                        showSoundID = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                            showSoundID = false
                        }
                    }) {
                        Text("Show Possible Sound IDs?").font(.title)
                    }
                    .glassBackgroundEffect()
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
    
    private func startASUTask() {
        let databaseRef = Database.database().reference()
        databaseRef.child("ASUStartRecording").setValue(true)
        isWaitingResponse = true
    }
    
    private func observeAPIResponse() {
        let databaseRef = Database.database().reference()
        databaseRef.child("ASUResponse").observe(.value) { snapshot in
            if let response = snapshot.value as? String, response != "NA" {

                
                DispatchQueue.main.async {
                    // Convert JSON Data
                    if let jsonData = response.data(using: .utf8) {
                        do {
                            let responseObjectJSON = try JSONDecoder().decode(APIResponseObject.self, from: jsonData)
                            let result = responseObjectJSON.result.capitalized
                            APIResponse = result
                            isWaitingResponse = false
                        } catch {
                            print("Error parsing JSON Code.")
                        }
                    }
                
//                    APIResponse = response
//                    isWaitingResponse = false
                }
            }
        }
    }
}

struct APIResponseObject: Codable {
    var result: String
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
//}

//#Preview {
//    AwarenessView()
//}
