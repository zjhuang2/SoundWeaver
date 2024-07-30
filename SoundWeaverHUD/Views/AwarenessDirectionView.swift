//
//  AwarenessDirectionView.swift
//  SoundWeaverHUD
//
//  Created by Jeremy Huang on 7/29/24.
//

import SwiftUI
import FirebaseDatabase
import Firebase

struct AwarenessDirectionView: View {
    @State private var directionLabel: String = "NA"
    
    var databaseRef: DatabaseReference!
    
    var body: some View {
        VStack {
            // Start Grid
            // Row 1
            VStack {
                HStack {
                    if directionLabel == "Front-left" {Image(systemName: "arrow.up.left")}
                }
                Spacer()
                HStack {
                    if directionLabel == "Front" {Image(systemName: "arrow.up")}
                }
                Spacer()
                HStack {
                    if directionLabel == "Front-right" {Image(systemName: "arrow.up.right")}
                }
            }
            // Row 2
            VStack {
                HStack {
                    if directionLabel == "Left" {Image(systemName: "arrow.left")}
                }
                Spacer()
                HStack {
                    if directionLabel == "Right" {Image(systemName: "arrow.right")}
                }
            }
            // Row 3
            VStack {
                HStack {
                    if directionLabel == "Back-left" {Image(systemName: "arrow.down.left")}
                }
                Spacer()
                HStack {
                    if directionLabel == "Back" {Image(systemName: "arrow.down")}
                }
                Spacer()
                HStack {
                    if directionLabel == "Back-right" {Image(systemName: "arrow.down.right")}
                }
            }
        }
        .font(.largeTitle)
        .padding()
        .onAppear(perform: loadDirection)
    }
    
    func loadDirection() {
        let databaseRef = Database.database().reference().child("direction").child("direction")
        
        databaseRef.observe(DataEventType.value) { snapshot in
            if let value = snapshot.value as? String {
                switch value {
                case "Front":
                    self.directionLabel = "Front"
                case "Front-left":
                    self.directionLabel = "Front-left"
                case "Front-right":
                    self.directionLabel = "Front-right"
                case "Left":
                    self.directionLabel = "Left"
                case "Right":
                    self.directionLabel = "Right"
                case "Back":
                    self.directionLabel = "Back"
                case "Back-left":
                    self.directionLabel = "Back-left"
                case "Back-right":
                    self.directionLabel = "Back-right"
                default:
                    self.directionLabel = "NA"
                }
            }
        }
    }
}

//#Preview {
//    AwarenessDirectionView()
//}
