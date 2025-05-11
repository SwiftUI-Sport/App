//
//  LottieView.swift
//  App
//
//  Created by Ali An Nuur on 10/05/25.
//

import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
    var name: String
    var loopMode: LottieLoopMode = .autoReverse
    var animationSpeed: CGFloat = 1.0
    var pingPong: Bool = true
    
    class Coordinator: NSObject {
        var animationView: LottieAnimationView?
        var isForward = true
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
     
        uiView.subviews.forEach { $0.removeFromSuperview() }
        
        let animationView = LottieAnimationView()
        context.coordinator.animationView = animationView
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        uiView.addSubview(animationView)
        
        NSLayoutConstraint.activate([
            animationView.widthAnchor.constraint(equalTo: uiView.widthAnchor),
            animationView.heightAnchor.constraint(equalTo: uiView.heightAnchor)
        ])
        
        // For .lottie files, we need to use DotLottieFile
        if let url = Bundle.main.url(forResource: name, withExtension: "lottie") {
            DotLottieFile.loadedFrom(url: url) { result in
                switch result {
                case .success(let dotLottieFile):
                    animationView.loadAnimation(from: dotLottieFile)
                    
                    if pingPong {
                        animationView.loopMode = .autoReverse
                        
                        // Set up ping-pong animation with completion handler
                        self.playWithPingPong(animationView, context: context)
                    } else {
                        animationView.loopMode = loopMode
                        animationView.animationSpeed = animationSpeed
                        animationView.play()
                    }
                    
                case .failure(let error):
                    print("⚠️ Failed to load .lottie file: \(error)")
                    
                    // Try JSON as fallback
                    if let jsonAnimation = LottieAnimation.named(name) {
                        animationView.animation = jsonAnimation
                        
                        if pingPong {
                            animationView.loopMode = .autoReverse
                            self.playWithPingPong(animationView, context: context)
                        } else {
                            animationView.loopMode = loopMode
                            animationView.animationSpeed = animationSpeed
                            animationView.play()
                        }
                    } else {
                        print("⚠️ Also failed to load as JSON: \(name)")
                    }
                }
            }
        } else {
            // Try JSON format
            if let jsonAnimation = LottieAnimation.named(name) {
                animationView.animation = jsonAnimation
                
                if pingPong {
                    animationView.loopMode = .autoReverse
                    self.playWithPingPong(animationView, context: context)
                } else {
                    animationView.loopMode = loopMode
                    animationView.animationSpeed = animationSpeed
                    animationView.play()
                }
            } else {
                print("⚠️ Animation file not found: \(name)")
            }
        }
    }
    
    private func playWithPingPong(_ animationView: LottieAnimationView, context: Context) {
        // Simply use the built-in autoReverse loop mode
        animationView.loopMode = .autoReverse
        animationView.animationSpeed = abs(animationSpeed)
        animationView.play()
    }
}


struct LottieLihat: UIViewRepresentable {
    let url: URL
    
    func makeUIView(context: Context) -> UIView {
        UIView()
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        let animationView = LottieAnimationView()
        animationView.translatesAutoresizingMaskIntoConstraints = false
        uiView.addSubview(animationView)
        
        NSLayoutConstraint.activate([
            animationView.widthAnchor.constraint(equalTo: uiView.widthAnchor),
            animationView.heightAnchor.constraint(equalTo: uiView.heightAnchor)
            ])
        
        DotLottieFile.loadedFrom(url: url) { result in
            switch result {
            case .success(let success):
                animationView.loadAnimation(from: success)
                animationView.loopMode = .autoReverse
//                animationView.m
                animationView.play()
            case .failure(let error):
                print(error)
            }
        }
                
    }
        
}

struct TestLottieLihat: View {
   
    
    var body: some View {
        VStack(spacing: 8) {

            LottieLihat(url: Bundle.main.url(forResource: "logo", withExtension: "lottie")!)
                .frame(width: 280, height: 280)
                .padding(.bottom, 50)
        }
    }
}

struct TestLottieView: View {
    init() {
        // Check if the animation file exists
        if let lottieURL = Bundle.main.url(forResource: "logo", withExtension: "lottie") {
            print("Found animation at: \(lottieURL)")
        } else {
            print("⚠️ Animation file 'logo.lottie' not found!")
            
            // List all .lottie files in the bundle for debugging
            let lottieFiles = Bundle.main.paths(forResourcesOfType: "lottie", inDirectory: nil)
            print("Available .lottie files: \(lottieFiles)")
        }
    }
    
    var body: some View {
        VStack(spacing: 8) {
            
            LottieView(name: "lottie_1")
//                .frame(width: 280, height: 280)
//                .padding(.bottom, 50)
            
           
        }
    }
}

#Preview {
    TestLottieView()
}

