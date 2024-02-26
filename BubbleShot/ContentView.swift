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
    @State private var timeCache = 30
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
                    Text("You shot \(counter.ballCounter) red balls in \(timeCache) seconds.")
                        .font(.system(size: 64))
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    Button("Retry!") {
                        finishGame = false
                        readyTime = 3
                        counter.ballCounter = 0
                        gameStart = false
                    }
                } else {
                    if !gameStart {
                        Text("Shot \(counter.ballMax) red balls in \(timeCache) seconds!")
                            .font(.system(size: 54))
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        HStack(spacing: 200) {
                            VStack {
                                Text("Time Setting")
                                    .font(.system(size: 28))
                                    .padding(.top, 20)
                                    .padding(.bottom, 10)
                                HStack {
                                    Button("15s") {
                                        timeCache = 15
                                    }
                                    Button("30s") {
                                        timeCache = 30
                                    }
                                    Button("60s") {
                                        timeCache = 60
                                    }
                                }
                            }
                            VStack {
                                Text("Red Ball Setting")
                                    .font(.system(size: 28))
                                    .padding(.top, 20)
                                    .padding(.bottom, 10)
                                HStack {
                                    Button("50") {
                                        counter.ballMax = 50
                                    }
                                    Button("80") {
                                        counter.ballMax = 80
                                    }
                                    Button("100") {
                                        counter.ballMax = 100
                                    }
                                }
                            }
                        }
                        Spacer(minLength: 20)
                        Button("Let's Go!") {
                            gameStart = true
                            timeRemaining = timeCache
                            soundManager.playAudio(fileName: "countdown")
                        }
                            .toggleStyle(.button)
                            .font(.system(size: 30))
                            .frame(width: 360, height: 120)
                        
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
                        Text("you shot \(counter.ballCounter)/\(counter.ballMax) bubble!!")
                            .font(.system(size: 52))
                            .fontWeight(.semibold)
                        Button("Stop") {
                            gameStart = false
                            showImmersiveSpace = false
                            finishGame = true
                            timer.upstream.connect().cancel()
                        }
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
