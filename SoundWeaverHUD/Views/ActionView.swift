//
//  ActionView.swift
//  SoundWeaverHUD
//
//  Created by Jeremy Huang on 7/28/24.
//

import SwiftUI

struct ActionView: View {
    var body: some View {
        VStack {
            Text("Direction").font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
            AwarenessDirectionView()
        }
    }
}

#Preview {
    ActionView()
}
