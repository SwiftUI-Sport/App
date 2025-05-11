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
        var isLoading = false
        var animationLoaded = false
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        
        // Create animation view during initialization
        let animationView = LottieAnimationView()
        let loadingIndicator = UIActivityIndicatorView(style: .medium)
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(animationView)
        view.addSubview(loadingIndicator)
        
        NSLayoutConstraint.activate([
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor),
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        context.coordinator.animationView = animationView
        loadingIndicator.startAnimating()
        
        // Start loading animation asynchronously
        loadAnimationAsync(name: name, animationView: animationView, loadingIndicator: loadingIndicator, coordinator: context.coordinator)
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        // Only load animation if we haven't already started loading or loaded
        if !context.coordinator.isLoading && !context.coordinator.animationLoaded {
            // Find existing animation view and loading indicator
            let animationView = context.coordinator.animationView
            let loadingIndicator = uiView.subviews.compactMap { $0 as? UIActivityIndicatorView }.first
            
            if let animationView = animationView, let loadingIndicator = loadingIndicator {
                loadAnimationAsync(name: name, animationView: animationView, loadingIndicator: loadingIndicator, coordinator: context.coordinator)
            }
        }
    }
    
    private func loadAnimationAsync(name: String, animationView: LottieAnimationView, loadingIndicator: UIActivityIndicatorView, coordinator: Coordinator) {
        // Mark that we're starting to load
        coordinator.isLoading = true
        
        // Load animation in background thread
        DispatchQueue.global(qos: .userInitiated).async {
            // Try loading .lottie file format first
            if let url = Bundle.main.url(forResource: name, withExtension: "lottie") {
                DotLottieFile.loadedFrom(url: url) { result in
                    DispatchQueue.main.async {
                        loadingIndicator.stopAnimating()
                        loadingIndicator.isHidden = true
                        
                        switch result {
                        case .success(let dotLottieFile):
                            animationView.loadAnimation(from: dotLottieFile)
                            
                            if pingPong {
                                animationView.loopMode = .autoReverse
                                self.playWithPingPong(animationView, coordinator: coordinator)
                            } else {
                                animationView.loopMode = loopMode
                                animationView.animationSpeed = animationSpeed
                                animationView.play()
                            }
                            
                            coordinator.animationLoaded = true
                            
                        case .failure(let error):
                            print("⚠️ Failed to load .lottie file: \(error)")
                            self.tryLoadingJSON(name: name, animationView: animationView, coordinator: coordinator)
                        }
                        coordinator.isLoading = false
                    }
                }
            } else {
                // Try JSON format if .lottie file not found
                DispatchQueue.main.async {
                    loadingIndicator.stopAnimating()
                    loadingIndicator.isHidden = true
                    self.tryLoadingJSON(name: name, animationView: animationView, coordinator: coordinator)
                    coordinator.isLoading = false
                }
            }
        }
    }
    
    private func tryLoadingJSON(name: String, animationView: LottieAnimationView, coordinator: Coordinator) {
        // Try loading as JSON in background
        DispatchQueue.global(qos: .userInitiated).async {
            let animation = LottieAnimation.named(name)
            
            DispatchQueue.main.async {
                if let jsonAnimation = animation {
                    animationView.animation = jsonAnimation
                    
                    if pingPong {
                        animationView.loopMode = .autoReverse
                        self.playWithPingPong(animationView, coordinator: coordinator)
                    } else {
                        animationView.loopMode = loopMode
                        animationView.animationSpeed = animationSpeed
                        animationView.play()
                    }
                    
                    coordinator.animationLoaded = true
                } else {
                    print("⚠️ Animation file not found: \(name)")
                }
            }
        }
    }
    
    private func playWithPingPong(_ animationView: LottieAnimationView, coordinator: Coordinator) {
        animationView.loopMode = .autoReverse
        animationView.animationSpeed = abs(animationSpeed)
        animationView.play()
    }
}

struct LottieLihat: UIViewRepresentable {
    let url: URL
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        let animationView = LottieAnimationView()
        let loadingIndicator = UIActivityIndicatorView(style: .medium)
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(animationView)
        view.addSubview(loadingIndicator)
        
        NSLayoutConstraint.activate([
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor),
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        loadingIndicator.startAnimating()
        
        // Load animation asynchronously
        DispatchQueue.global(qos: .userInitiated).async {
            DotLottieFile.loadedFrom(url: url) { result in
                DispatchQueue.main.async {
                    loadingIndicator.stopAnimating()
                    loadingIndicator.isHidden = true
                    
                    switch result {
                    case .success(let dotLottieFile):
                        animationView.loadAnimation(from: dotLottieFile)
                        animationView.loopMode = .autoReverse
                        animationView.play()
                    case .failure(let error):
                        print("⚠️ Failed to load animation: \(error)")
                    }
                }
            }
        }
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        // No updates needed as everything is handled in makeUIView
    }
}

struct TestLottieLihat: View {
    var body: some View {
        VStack(spacing: 8) {
            if let url = Bundle.main.url(forResource: "logo", withExtension: "lottie") {
                LottieLihat(url: url)
                    .frame(width: 280, height: 280)
                    .padding(.bottom, 50)
            } else {
                Text("Animation not found")
            }
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
                .frame(width: 280, height: 280)
        }
    }
}

#Preview {
    TestLottieView()
}
