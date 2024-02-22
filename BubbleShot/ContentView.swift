//
//  ContentView.swift
//  BubbleShot
//
//  Created by unboxers on 2/13/24.
//

import SwiftUI
import RealityKit

struct ContentView: View {
    @State private var timeRemaining = 30
    @State private var readyTime = 3
    @State private var gameStart = false
    @State private var finishGame = false

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    let readyTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var soundManager = SoundManager()
    var bgmManager = BGMManager()
    
    @State var showImmersiveSpace = false
    
    @EnvironmentObject var counter: CounterModel

    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace

    var body: some View {
        NavigationStack {
            VStack {
                if finishGame {
                    Text("Game Over!")
                        .font(.system(size: 30))
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    Text("You shot \(counter.ballCounter) red balls in 30 seconds.")
                        .font(.system(size: 64))
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    Button("Retry!") {
                        finishGame = false
                        readyTime = 3
                        soundManager.playAudio(fileName: "countdown")
                        counter.ballCounter = 0
                        timeRemaining = 30
                        gameStart = true
                    }
                } else {
                    if !gameStart {
                        Text("Shoot 50 red balls in 30 seconds!")
                            .font(.system(size: 64))
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        Button("Let's Go!") {
                            gameStart = true
                            soundManager.playAudio(fileName: "countdown")
                        }
                            .toggleStyle(.button)
                            .font(.system(size: 30))
                            .frame(width: 200, height: 80)
                    } else if !showImmersiveSpace {
                        Text("\(readyTime)")
                            .font(.system(size: 160))
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            .onReceive(timer) { _ in
                                if readyTime > 1 {
                                    readyTime -= 1
                                } else {
                                    bgmManager.playBGM()
                                    showImmersiveSpace = true
                                    timer.upstream.connect().cancel()
                                            }
                                        }
                    }
                    if gameStart && showImmersiveSpace {
                        Text("\(timeRemaining)")
                            .font(.system(size: 142))
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            .onReceive(timer) { _ in
                                if timeRemaining > 0 {
                                    timeRemaining -= 1
                                } else {
                                    bgmManager.stop()
                                    print("타이머 종료")
                                    soundManager.playAudio(fileName: "start")
                                    gameStart = false
                                    showImmersiveSpace = false
                                    finishGame = true
                                    timer.upstream.connect().cancel()
                                            }
                                        }
                        Text("you shot \(counter.ballCounter)/50 bubble!!")
                            .font(.system(size: 52))
                            .fontWeight(.semibold)
                    }
                }
            }
        }.frame(width: 1100, height: 500)
        .onChange(of: showImmersiveSpace) { _, newValue in
            Task {
                if newValue {
                    await openImmersiveSpace(id: "ImmersiveSpace")
                } else {
                    await dismissImmersiveSpace()
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
