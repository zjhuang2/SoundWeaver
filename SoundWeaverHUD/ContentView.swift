//
//  ContentView.swift
//  SoundWeaverHUD
//
//  Created by Jeremy Huang on 7/28/24.
//

import SwiftUI
import RealityKit
import RealityKitContent

let anchor = AnchorEntity(.head)

struct ContentView: View {
    
    //    @State var isSensing = false
    //    @State var currentMode: String = "Awareness"
    //
    //    var classificationState = AudioClassificationState()
    //    @State var classificationConfig = AudioClassificationConfiguration()
    //
    //    @State var transcriptText: String = "Go ahead, I am listening."
    //
    //    /// A collection of contexts for awareness evaluation.
    //    @State var homeSounds: Set<SoundIdentifier> = [SoundIdentifier(labelName: "door"), SoundIdentifier(labelName: "knock")]
    //    @State var workSounds: Set<SoundIdentifier> = [SoundIdentifier(labelName: "door"), SoundIdentifier(labelName: "knock")]
    //    @State var mtgSounds: Set<SoundIdentifier> = [SoundIdentifier(labelName: "door"), SoundIdentifier(labelName: "knock")]
    //
    //    /// A collection of tasks for task evaluation
    //    @State var nursingTaskSounds: Set<SoundIdentifier> = [SoundIdentifier(labelName: "door"), SoundIdentifier(labelName: "knock")]
    //    @State var cookingTaskSounds: Set<SoundIdentifier> = [SoundIdentifier(labelName: "door"), SoundIdentifier(labelName: "knock")]
    
    var body: some View {
        RealityView { content, attachments in
            if let scene = try? await Entity(named: "Immersive", in: realityKitContentBundle) {
                scene.setParent(anchor)
                content.add(anchor)
                anchor.addChild(scene)
                
                // Z Offsets
                scene.transform.translation.z = -0.25
                scene.transform.translation.y = -1.5
                scene.transform.translation.x = 0
                
                if let swAttachment = attachments.entity(for: "swAttachment") {
                    swAttachment.transform.translation.z = -1.6
                    swAttachment.transform.translation.y = -0.1
                    anchor.addChild(swAttachment)
                }
            }
        } attachments: {
            Attachment(id: "swAttachment") {
                HUDView()
            }
        }
    }
}
//        VStack {
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
//                        startTranscribing()
//                        isSensing.toggle()
//                    } else {
//                        // stop audio classification and speech recognition
//                        AudioClassifier.singleton.stopSoundClassification()
//                        stopTranscribing()
//                        isSensing.toggle()
//                    }
//                }) {
//                    Text(isSensing ? "Stop Sensing" : "Start Sensing")
//                }
//                .glassBackgroundEffect()
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
//                    TranscriptView(transcriptText: transcriptText)
//                }
//            }
//            
////            TabView {
////                AwarenessView(classificationState: classificationState,
////                              classificationConfig: $classificationConfig,
////                              homeSounds: homeSounds,
////                              workSounds: workSounds,
////                              mtgSounds: mtgSounds,
////                              isSensing: $isSensing)
////                    .tabItem {
////                        Label("Awareness", systemImage: "eye")
////                    }
////                    .onAppear {currentMode = "Awareness"}
////
////                ActionView()
////                    .tabItem {
////                        Label("Action", systemImage: "bolt")
////                    }
////                    .onAppear {currentMode = "Action"}
////
////                TranscriptView(transcriptText: transcriptText)
////                    .tabItem {
////                        Label("Social", systemImage: "person.2")
////                    }
////                    .onAppear {currentMode = "Social"}
////            }
//        }
//        .onAppear {
//            AudioSessionManager.shared
//        }
    
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

#Preview(immersionStyle: .mixed) {
    ContentView()
}
