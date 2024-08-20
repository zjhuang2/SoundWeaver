//
//  ActionView.swift
//  SoundWeaverHUD
//
//  Created by Jeremy Huang on 7/28/24.
//

import SwiftUI

struct ActionView: View {
    
    var currentActionModeTaskName = DataManager.shared.currentActionModeTaskName
    var currentActionModeSounds = DataManager.shared.currentActionModeSounds
    
    var currentPinnedSoundItems = DataManager.shared.currentPinnedActionModeSounds
    var currentGeneralSoundItems = DataManager.shared.currentGeneralActionModeSounds
    
//    var pinnedSoundItems = current.sounds.filter { $0.pinned }
//    var generalSoundItems = DataManager.shared.activeTask.sounds.filter { !$0.pinned }
    
    var body: some View {
        VStack {
            Text("Direction").font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
            DirectionView()
        }
        
        // Pinned Sound Labels
        VStack {
            Text("\(currentPinnedSoundItems)")
            ActionView.displayPinnedSoundLabelsGrid(pinnedSoundItems: currentPinnedSoundItems)
        }
        
        // Other Labels
        VStack {
            Text("\(currentGeneralSoundItems)")
            ActionView.displayGeneralSoundLabelsGrid(generalSoundItems: currentGeneralSoundItems)
        }
    }
    
    // FOR PINNED SOUND LABELS
    static func displayPinnedSoundLabelsGrid(pinnedSoundItems: [[String: Any]]) -> some View {
        return HStack {
            ForEach(0 ..< pinnedSoundItems.count, id: \.self) { index in
                if let labelName = pinnedSoundItems[index]["labelName"] as? String,
                   let activeState = pinnedSoundItems[index]["activeState"] as? Bool {
                    generatePinnedSoundLabel(labelName: labelName, activeState: activeState)
                }
            }
        }
    }
    
    /// Generate individual sound label.
    static func generatePinnedSoundLabel(labelName: String, activeState: Bool) -> some View {
        return VStack {
            Button {
                // No Actions
            } label: {
                Text("\(labelName)")
                    .font(.title3)
                    .fixedSize(horizontal: false, vertical: true)
                    .multilineTextAlignment(.center)
                    .padding()
            }
            .glassBackgroundEffect()
            .tint(activeState == true ? Color.green : Color.gray)
        }
    }
    
    // FOR OTHER SOUND LABELS
    static func displayGeneralSoundLabelsGrid(generalSoundItems: [[String: Any]]) -> some View {
        return HStack {
            ForEach(0 ..< generalSoundItems.count, id: \.self) { index in
                if let labelName = generalSoundItems[index]["labelName"] as? String,
                   let activeState = generalSoundItems[index]["activeState"] as? Bool {
                    if activeState { // Only appear if active
                        generateGeneralSoundLabel(labelName: labelName)
                    }
                }
            }
        }
    }
    
    static func generateGeneralSoundLabel(labelName: String) -> some View {
        return VStack {
            Text("\(labelName)")
                .font(.title3)
                .fixedSize(horizontal: false, vertical: true)
                .multilineTextAlignment(.center)
                .padding()
                .frame(height: 100)
                .glassBackgroundEffect()
        }
    }
    

}

#Preview {
    ActionView()
}
