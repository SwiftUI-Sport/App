//
//  onBoardingView.swift
//  App
//
//  Created by Ali An Nuur on 08/05/25.
//

import SwiftUI

// MARK: - Model
struct OnboardingPage: Identifiable {
    let id = UUID()
    let imageName: String
    let title: String
    let description: String
}

// MARK: - ViewModel
// Modifikasi pada OnboardingViewModel di onBoardingView.swift
final class OnboardingViewModel: ObservableObject {
    @Published var currentPage: Int = 0
    @AppStorage("isOnboardingCompleted") var isOnboardingCompleted: Bool = false
    @Published var isAuthorizationInProgress: Bool = false
    
    let pages: [OnboardingPage] = [
        .init(imageName: "lottie_1", title: "Run or Rest? We'll Tell You!", description: "No more guessing, we'll help you decide when to run and when your body needs to recover."),
        .init(imageName: "lottie_2", title: "Allow Access to Health", description: "Runday need your permission to uses your Health data to give you the best recomendation."),
        .init(imageName: "lottie_3", title: "We're Almost Done, Let's Start!", description: "You're all set! Just one more steps we'll start delivering your recomendation tailored to your body's needs."),
    ]
    
    var isLastPage: Bool {
        currentPage == pages.count - 1
    }
    
    func nextPage() {
        if !isLastPage {
            withAnimation { currentPage += 1 }
        }
    }
    
    func previousPage() {
        if currentPage > 0 {
            withAnimation { currentPage -= 1 }
        }
    }
    
    func completeOnboarding() {
        isOnboardingCompleted = true
    }
}

// MARK: - Views
struct OnboardingView: View {
    @StateObject private var viewModel = OnboardingViewModel()
    @EnvironmentObject var healthKitViewModel: HealthKitViewModel
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            TabView(selection: $viewModel.currentPage) {
                ForEach(Array(viewModel.pages.enumerated()), id: \.element.id) { index, page in
                    OnboardingPageView(page: page)
                        .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .edgesIgnoringSafeArea(.bottom)
            
            PageIndicator(currentPage: viewModel.currentPage, pageCount: viewModel.pages.count)
                .padding(.vertical, 16)
                .padding(.top, 20)
                .padding(.bottom, 20)
            
            NavigationButtons(
                currentPage: viewModel.currentPage,
                isLastPage: viewModel.isLastPage,
                onNext: {
                    if viewModel.isLastPage {
                        if healthKitViewModel.isAuthorized {
                            viewModel.isAuthorizationInProgress = false
                            healthKitViewModel.loadAge()    
//                            viewModel.completeOnboarding()
                            healthKitViewModel.loadAllData()
                            healthKitViewModel.loadHeartRateVariability()
                            healthKitViewModel.loadHeartRate()
                            healthKitViewModel.loadRestingHeartRateDaily()
                            healthKitViewModel.loadPast7DaysWorkoutTSR()

                        } else {
                            viewModel.isAuthorizationInProgress = true
                            healthKitViewModel.start()
                        }
                    } else {
                        viewModel.nextPage()
                    }
                },
                onBack: viewModel.previousPage,
                viewModel: viewModel
            )
            .padding(.horizontal, 30)
        }
        .padding(.bottom, 100)
        .background(Color(.systemBackground))
        .onChange(of: healthKitViewModel.isAuthorized) { _, isAuthorized in
                DispatchQueue.main.async {
                    viewModel.isAuthorizationInProgress = false
                    healthKitViewModel.loadAllData()
                    healthKitViewModel.loadHeartRateVariability()
                    healthKitViewModel.loadHeartRate()
                    healthKitViewModel.loadRestingHeartRateDaily()
                    healthKitViewModel.loadPast7DaysWorkoutTSR()
                }
        }
        .onChange(of: healthKitViewModel.stressHistory42Days) { _, _ in
            // Update when data changes
            viewModel.completeOnboarding()

        }
        .onChange(of: healthKitViewModel.errorMessage) { _, errorMessage in
            if errorMessage != nil {
                DispatchQueue.main.async {
                    viewModel.isAuthorizationInProgress = false
                }
            }
        }
    }
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    
    var body: some View {
        VStack(spacing: 8) {
            Spacer()
            LottieView(name: page.imageName)
                .frame(maxWidth: 280, maxHeight: 280)
                .accessibility(hidden: true)
                .padding(.bottom, 50)
            
            Text(page.title)
                .font(.system(.largeTitle, weight: .bold))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
                .frame(minHeight: 100, alignment: .top)
            
            
            Text(page.description)
                .font(.system(.body))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
                .frame(minHeight: 50)
            
        }
    }
}

struct PageIndicator: View {
    let currentPage: Int
    let pageCount: Int
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<pageCount, id: \.self) { index in
                Circle()
                    .fill(index == currentPage ? Color("primary_1") : Color.gray.opacity(0.3))
                    .frame(width: 8, height: 8)
            }
        }
    }
}

struct NavigationButtons: View {
    let currentPage: Int
    let isLastPage: Bool
    let onNext: () -> Void
    let onBack: () -> Void
    @ObservedObject var viewModel: OnboardingViewModel
    @EnvironmentObject var healthKitViewModel: HealthKitViewModel
    
    var body: some View {
        HStack {
            Button(action: onNext) {
                if viewModel.isAuthorizationInProgress && isLastPage {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .frame(height: 44)
                        .frame(maxWidth: .infinity)
                        .background(Color("primary_1").opacity(0.5))
                        .cornerRadius(8)
                } else {
                    Text(isLastPage ? "Get Started" : "Next")
                        .fontWeight(.semibold)
                        .frame(height: 44)
                        .frame(maxWidth: .infinity)
                        .background(Color("primary_1"))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .buttonStyle(.plain)
            .disabled(viewModel.isAuthorizationInProgress)
        }
    }
}

// MARK: - Preview
//struct OnboardingView_Previews: PreviewProvider {
//    static var previews: some View {
//        OnboardingView()
//    }
//}
