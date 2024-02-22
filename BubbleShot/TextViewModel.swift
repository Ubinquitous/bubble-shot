//
//  TextViewModel.swift
//  curved-screen
//
//  Created by unboxers on 2/19/24.
//

import SwiftUI
import RealityKit

class TextViewModel {
    
    private var contentEntity = Entity()

    func setupContentEntity() -> Entity {
        return contentEntity
    }

    func addText(text: String) -> Entity {

        let textMeshResource: MeshResource = .generateText(text,
                                                           extrusionDepth: 0.05,
                                                           font: .systemFont(ofSize: 0.3),
                                                           containerFrame: .zero,
                                                           alignment: .center,
                                                           lineBreakMode: .byWordWrapping)

        let material = UnlitMaterial(color: .white)

        let textEntity = ModelEntity(mesh: textMeshResource, materials: [material])
        textEntity.position = SIMD3(x: 0, y: 1.4, z: -1.6)

        contentEntity.addChild(textEntity)

        return textEntity
    }
}
