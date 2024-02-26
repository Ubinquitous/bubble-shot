//
//  CounterModel.swift
//  BubbleShot
//
//  Created by unboxers on 2/20/24.
//

import Foundation

class CounterModel: ObservableObject {
    @Published var ballCounter = 0
    @Published var ballMax = 50
}
