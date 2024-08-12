//
//  SoundLevelVisualizerView.swift
//  SoundWeaverHUD
//
//  Created by Jeremy Huang on 8/11/24.
//

import SwiftUI

struct VisualizerView: View {
    
    var body: some View {
        VStack {
            WaveformView(amplitudes: SoundLevelMonitor.shared.amplitudes)
                .stroke(Color.white, lineWidth: 2)
                .frame(height: 200)
                .padding()
        }
    }
}

struct WaveformView: Shape {
    var amplitudes: [CGFloat]

    func path(in rect: CGRect) -> Path {
        var path = Path()

        let width = rect.width / CGFloat(amplitudes.count)

        for (index, amplitude) in amplitudes.enumerated() {
            let x = CGFloat(index) * width
            let y = rect.height / 2 + amplitude * rect.height / 2

            if index == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }

        return path
    }

    var animatableData: [CGFloat] {
        get { amplitudes }
        set { amplitudes = newValue }
    }
}

#Preview {
    VisualizerView()
}
