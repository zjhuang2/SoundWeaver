//
//  TaskItem.swift
//  SoundWeaverHUD
//
//  Created by Jeremy Huang on 8/18/24.
//

import Foundation
import Firebase

struct ActionModeSoundItem: Identifiable, Codable {
    var id = UUID()
    var labelName: String
    var pinned: Bool
    var activeState: Bool
}

struct ActiveTask: Identifiable, Codable {
    var id = UUID()
    var taskName: String
    var sounds: [ActionModeSoundItem]
}
