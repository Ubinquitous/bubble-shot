//
//  ViewModel.swift
//  BubbleShot
//
//  Created by unboxers on 2/19/24.
//

import Foundation
import SwiftUI
import RealityKit
import AVFoundation

@Observable
class ViewModel {
    private var size: Float = 1
    private var textY = 1.4
    private var contentEntity = Entity()
    private let colors: [SimpleMaterial.Color] = [
        .gray, 
        .orange,
        .yellow,
        .green,
        .blue,
        .purple,
        .brown,
        .blue,
        .cyan,
        .magenta,
        .white
    ]
    
    private var soundManager = SoundManager()

    func setupContentEntity() -> Entity {
        return contentEntity
    }

    func getTargetEntity(name: String) -> Entity? {
        return contentEntity.children.first { $0.name == name}
    }

    func addCube(name: String, redball: String) -> Entity {
        
        let entity = ModelEntity(
            mesh: .generateBox(size: 1, cornerRadius: 9999),
            materials: [SimpleMaterial(color: .red, isMetallic: false)],
            collisionShape: .generateBox(size: SIMD3<Float>(repeating: 0.5)),
            mass: 0.0
        )
        
        
        entity.name = name

        entity.components.set(InputTargetComponent(allowedInputTypes: .indirect))
        entity.components.set(HoverEffectComponent())
        
        let material = PhysicsMaterialResource.generate(friction: 0.8, restitution: 0.0)
        entity.components.set(PhysicsBodyComponent(shapes: entity.collision!.shapes,
                                                   mass: 0.0,
                                                   material: material,
                                                   mode: .dynamic))

        entity.position = SIMD3(x: Float.random(in: -10...10), y: Float.random(in: -10...10), z: Float.random(in: -10...10))

        let go = FromToByAnimation<Transform>(
                    name: "go",
                    from: .init(scale: .init(repeating: 1), translation: entity.position),
                    to: .init(scale: .init(repeating: 1), translation: SIMD3(x: Float.random(in: -20...20), y: Float.random(in: -20...20), z: Float.random(in: -20...20))),
                    duration: 31,
//                    timing: .easeIn,
                    bindTarget: .transform
                )
        
        let goAnimation = try! AnimationResource
                    .generate(with: go)
        
        let animation = try! AnimationResource.sequence(with: [goAnimation,goAnimation,goAnimation])

        entity.playAnimation(animation, transitionDuration: 31)
        
        contentEntity.addChild(entity)

        
        return entity
    }

    
    func addCube(name: String) -> Entity {
        
        let entity = ModelEntity(
            mesh: .generateBox(size: 1, cornerRadius: 9999),
            materials: [SimpleMaterial(color: colors.randomElement()!, isMetallic: false)],
            collisionShape: .generateBox(size: SIMD3<Float>(repeating: 0.5)),
            mass: 0.0
        )
        
        
        entity.name = name

        entity.components.set(InputTargetComponent(allowedInputTypes: .indirect))
        entity.components.set(HoverEffectComponent())
        
        let material = PhysicsMaterialResource.generate(friction: 0.8, restitution: 0.0)
        entity.components.set(PhysicsBodyComponent(shapes: entity.collision!.shapes,
                                                   mass: 0.0,
                                                   material: material,
                                                   mode: .dynamic))

        entity.position = SIMD3(x: Float.random(in: -10...10), y: Float.random(in: -10...10), z: Float.random(in: -10...10))

        let go = FromToByAnimation<Transform>(
                    name: "go",
                    from: .init(scale: .init(repeating: 1), translation: entity.position),
                    to: .init(scale: .init(repeating: 1), translation: SIMD3(x: Float.random(in: -20...20), y: Float.random(in: -20...20), z: Float.random(in: -20...20))),
                    duration: 31,
                    timing: .easeIn,
                    bindTarget: .transform
                )
        
        let goAnimation = try! AnimationResource
                    .generate(with: go)
        
        let animation = try! AnimationResource.sequence(with: [goAnimation,goAnimation,goAnimation])

        entity.playAnimation(animation, transitionDuration: 31)
        
        contentEntity.addChild(entity)

        
        return entity
    }

    func changeToRandomColor(entity: Entity) {
        guard let _entity = entity as? ModelEntity else { return }
        _entity.model?.materials = [SimpleMaterial(color: colors.randomElement()!, isMetallic: false)]
    }
    
    func getColorsFromModelEntity(modelEntity: ModelEntity) -> Any {
        var colors: [Any] = []

        // ModelEntity의 모든 재질을 확인합니다.
        for material in modelEntity.model?.materials ?? [] {
            if let simpleMaterial = material as? SimpleMaterial {
                // SimpleMaterial의 color를 가져와서 배열에 추가합니다.
                // swiftlint:disable next line
                colors.append(simpleMaterial)
            }
        }
        return colors[0]
    }
    
    var bgmManager = BGMManager()

    func removeModel(entity: Entity) -> Bool {
        guard let _entity = entity as? ModelEntity else { return false }
//        print("\(getColorsFromModelEntity(modelEntity: _entity))")
//        print("\n\n\n\n\n")
        if let colors = getColorsFromModelEntity(modelEntity: _entity) as? SimpleMaterial {
            if("\(colors.color.tint)".contains("1 0 0 1")) {
                soundManager.playAudio(fileName: "touch")
                bgmManager.playBGM()
                let fadeOut = FromToByAnimation<Transform>(
                            name: "fadeOut",
                            from: .init(scale: .init(repeating: 1), translation: entity.position),
                            to: .init(scale: .init(repeating: 0), translation: entity.position),
                            duration: 0.5,
                            timing: .easeOut,
                            bindTarget: .transform
                        )
                let fadeOutAnimation = try! AnimationResource
                            .generate(with: fadeOut)
                
                let animation = try! AnimationResource.sequence(with: [fadeOutAnimation])

                _entity.playAnimation(animation, transitionDuration: 0.3)
//                let audioFileURL = URL(fileURLWithPath: "./Assets.xcassets/touch.mp3")
//                let audioPlayer = try! AVAudioPlayer(contentsOf: audioFileURL)
//                audioPlayer.play()
//                _entity.removeFromParent()
                return true
            }
            _entity.model?.mesh = .generateBox(size: 2, cornerRadius: 9999)
            soundManager.playAudio(fileName: "beep")
//            bgmManager.playBGM()
            return false
        } else {
            print("error")
        }
        return false
    }
}
