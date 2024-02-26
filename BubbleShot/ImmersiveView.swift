//
//  ImmersiveView.swift
//  BubbleShot
//
//  Created by unboxers on 2/15/24.
//
import SwiftUI
import RealityKit
import RealityKitContent
import Combine

struct ImmersiveView: View {
    @State var cubeList: [Entity] = []

    @EnvironmentObject var counter: CounterModel
    
    func correct() {
        counter.ballCounter += 1
    }
    
    private let colors: [SimpleMaterial.Color] = [.gray, .red, .orange, .yellow, .green, .blue, .purple]
    
    @State var model = ViewModel()
    var body: some View {
        RealityView { content in
            if let scene = try? await Entity(named: "ImmersiveScene",  in: realityKitContentBundle) {
                content.add(scene)
            }
            content.add(model.setupContentEntity())
            
            for index in 0..<counter.ballMax {
                cubeList.append(Entity())
                cubeList[index] = model.addCube(name:  "Cube\(index + 1)", redball: "true")
            }
            for index in counter.ballMax..<300 {
                cubeList.append(Entity())
                cubeList[index] = model.addCube(name: "Cube\(index + 1)")
            }
        }
        .gesture(
            SpatialTapGesture()
                .targetedToAnyEntity()
                .onEnded { value in
                    if(model.removeModel(entity: value.entity)) {
                        correct()
                    }
                }
        )
    }
}

#Preview {
    ImmersiveView()
        .previewLayout(.sizeThatFits)
}
