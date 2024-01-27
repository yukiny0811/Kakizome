//
//  ContentView.swift
//  Kakizome
//
//  Created by Yuki Kuwashima on 2024/01/27.
//

import SwiftUI
import CoreMotion
import SwiftyCreatives

struct ContentView: View {
    
    let sketch = KakizomeSketch()
    
    var body: some View {
        ZStack {
            ConfigurableSketchView<DefaultOrthoConfig, MainDrawConfig>(sketch)
        }
    }
}

class KakizomeDrawConfig: DrawConfigBase {
    static var contentScaleFactor: Int = 3
    static var blendMode: SwiftyCreatives.BlendMode = .normalBlend
    static var clearOnUpdate: Bool = false
    static var frameRate: Int = 60
}

class KakizomeSketch: Sketch {
    
    private let motionManager = CMMotionManager()
    
    var points: [f3] = []
    
    var currentPos: f3 = .zero
    
    override init() {
        super.init()
        if motionManager.isDeviceMotionAvailable {
            motionManager.deviceMotionUpdateInterval = 0.001
            
            motionManager.startDeviceMotionUpdates(to: OperationQueue.main) { [weak self] data, error in
                guard let self else { return }
                guard let data = data else { return }
                let userAcceleration = data.userAcceleration
                let acc = f3.init(
                    -Float(userAcceleration.x),
                    -Float(userAcceleration.y),
                    0
                )
                currentPos += acc
                points.append(currentPos)
            }
        }
    }
    
    override func draw(encoder: SCEncoder) {
        color(1, 1, 1, 1)
        
        for p in points {
            rect(p * 100, 10, 10)
        }
    }
    
}
