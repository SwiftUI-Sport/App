//
//  FaqDetail.swift
//  App
//
//  Created by Ali An Nuur on 03/09/25.
//

import SwiftUI

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct FAQ: Identifiable {
    let id = UUID()
    let question: String
    let answer: String
    let category: String
}

public struct FaqDetail: View {
    @Environment(\.dismiss) private var dismiss
    @State private var searchText = ""
    @State private var selectedCategory = "All"
    @State private var expandedItems: Set<UUID> = []
    
    private let categories = ["All", "General", "Health Data", "Recommendations", "Calculations", "Health Metrics", "Training", "Technical"]
    
    private let faqs = [
        FAQ(question: "How does the app determine if I should run or rest?",
            answer: "The app analyzes multiple factors including your recent Training Stress Rating (TSR) trends, heart rate variability patterns, resting heart rate changes, and sleep data. While we don't provide direct run/rest recommendations, these metrics help you make informed decisions about your training readiness.",
            category: "Recommendations"),
        
        FAQ(question: "What health data does the app access?",
            answer: "The app accesses your heart rate, resting heart rate, heart rate variability, sleep data, and workout information from Apple Health. This data is used locally on your device to generate personalized recommendations.",
            category: "Health Data"),
        
        FAQ(question: "How is my fatigue level calculated?",
            answer: "The app provides separate recovery indicators rather than a single fatigue score. We analyze your heart rate variability trends, resting heart rate changes, recent training stress (TSR), and sleep quality independently. Each metric helps assess different aspects of your recovery state.",
            category: "Calculations"),
        
        FAQ(question: "What does the training load calculation include?",
            answer: "Training load is calculated using workout duration, intensity (based on heart rate zones), workout type, and frequency. High-intensity workouts contribute more to your load than easy runs. The calculation follows the TRIMP (Training Impulse) methodology used by sports scientists.",
            category: "Calculations"),
        
        FAQ(question: "How accurate are the heart rate zone calculations?",
            answer: "Heart rate zones are calculated using your maximum heart rate and resting heart rate to determine your heart rate reserve. The app uses 5 zones with percentages of your heart rate reserve. Accuracy depends on having correct max and resting heart rate values and your Apple Watch sensor quality.",
            category: "Health Data"),
        
        FAQ(question: "Is my health data secure and private?",
            answer: "Yes, absolutely. All your health data remains on your device and is never shared with third parties. We use Apple's HealthKit framework which ensures your data is encrypted and secure.",
            category: "Health Data"),
        
        FAQ(question: "Why do I need to wear my Apple Watch consistently?",
            answer: "Consistent data collection allows the app to better understand your patterns and provide more accurate recommendations. The more data we have, the better we can assess your recovery state.",
            category: "General"),
        
        FAQ(question: "How often should I update my fitness profile?",
            answer: "Update your profile when your fitness level changes significantly (every 2-3 months), after achieving new personal records, or if you notice recommendations seem off. Key metrics include resting heart rate, maximum heart rate, and fitness goals.",
            category: "General"),
        
        FAQ(question: "What should I do if my resting heart rate is elevated?",
            answer: "An elevated resting heart rate (5-10 bpm above normal) often indicates stress, illness, dehydration, or incomplete recovery. Consider taking a rest day, checking your hydration, sleep quality, and stress levels. If persistently elevated, consult a healthcare professional.",
            category: "Health Metrics"),
        
        FAQ(question: "How accurate are the recommendations?",
            answer: "Our recommendations are based on established sports science principles and validated algorithms. However, they should be used as guidance alongside listening to your body and consulting with healthcare professionals when needed.",
            category: "Recommendations"),
        
        FAQ(question: "What if I don't have enough data for recommendations?",
            answer: "If you don't have sufficient data, the app will guide you on how to improve data collection. Typically, you need at least a few days of consistent heart rate and activity data for accurate recommendations.",
            category: "Technical"),
        
        FAQ(question: "What are ATL, CTL, and TSB?",
            answer: "ATL (Acute Training Load) represents your recent training stress over approximately 7 days. CTL (Chronic Training Load) shows your longer-term fitness trends over about 42 days. TSB (Training Stress Balance) is the difference between CTL and ATL, indicating your freshness level.",
            category: "Calculations"),
        
        FAQ(question: "Can I train in different heart rate zones?",
            answer: "Yes! The app tracks time spent in each zone. Zone 1-2 are for easy/recovery runs, Zone 3 for aerobic base building, Zone 4 for tempo runs, and Zone 5 for high-intensity intervals. A balanced training plan includes all zones.",
            category: "Training"),
        
        FAQ(question: "How does sleep affect my training recommendations?",
            answer: "Poor sleep significantly impacts recovery and performance. The app considers sleep duration and quality (if available from your device) when making recommendations. Less than 7 hours or poor sleep quality may result in rest recommendations.",
            category: "Health Metrics"),
        
        FAQ(question: "What's the difference between active and passive recovery?",
            answer: "Active recovery involves light, low-intensity activities like easy walking, gentle yoga, or light cycling. Passive recovery is complete rest. The app may recommend active recovery when you need movement but shouldn't stress your body further.",
            category: "Training"),
        
        FAQ(question: "Can I override the app's recommendations?",
            answer: "Yes, these are recommendations, not strict rules. Always listen to your body. If you feel great despite a 'rest' recommendation, light activity may be fine. If you feel tired despite a 'run' recommendation, consider resting.",
            category: "General"),
        
        FAQ(question: "How does weather affect my training?",
            answer: "While the app doesn't directly factor weather, extreme temperatures can affect your heart rate and perceived exertion. In hot weather, your heart rate may be higher for the same effort. Adjust intensity accordingly and stay hydrated.",
            category: "Training"),
        
        FAQ(question: "What should I do if the app shows no data?",
            answer: "Make sure your Apple Watch is properly paired, you've granted health permissions, and you're wearing your device regularly. Check the Health app to ensure data is being collected properly.",
            category: "Technical"),
        
        FAQ(question: "How often are recommendations updated?",
            answer: "Recommendations are updated daily based on your latest health data. For the most current recommendation, make sure your Apple Watch data has synced with your iPhone.",
            category: "Recommendations"),
        
        FAQ(question: "What does heart rate variability (HRV) mean?",
            answer: "HRV measures the variation in time between heartbeats. Higher HRV generally indicates better recovery and readiness for training, while lower HRV may suggest you need more rest.",
            category: "Health Data"),
        
        FAQ(question: "How do I improve my heart rate variability?",
            answer: "Improve HRV through consistent sleep schedules, stress management, proper hydration, balanced training (avoiding overtraining), meditation or breathing exercises, and maintaining good nutrition. HRV responds to lifestyle changes over weeks to months.",
            category: "Health Metrics"),
        
        FAQ(question: "What causes my heart rate zones to change?",
            answer: "Heart rate zones can change due to improved fitness (lower heart rate for same effort), aging, medications, dehydration, illness, or changes in maximum heart rate. The app adapts to these changes over time.",
            category: "Health Metrics"),
        
        FAQ(question: "Should I train when I'm feeling sick?",
            answer: "Follow the 'neck rule': if symptoms are above the neck (runny nose, sneezing), light exercise may be okay. If symptoms are below the neck (chest congestion, body aches, fever), rest completely. When in doubt, prioritize recovery.",
            category: "Training"),
        
        FAQ(question: "How does the app handle irregular heart rhythms?",
            answer: "The app filters out obvious irregularities, but if you have a known heart condition or notice concerning patterns, consult your healthcare provider. The app is not a medical device and shouldn't replace professional medical advice.",
            category: "Health Data"),
        
        FAQ(question: "Can I use the app for other sports besides running?",
            answer: "Yes! The app works with any cardiovascular exercise tracked by your Apple Watch including cycling, swimming, rowing, or other cardio activities. The heart rate and recovery principles apply to all endurance sports.",
            category: "General")
    ]
    
    private var filteredFAQs: [FAQ] {
        let categoryFiltered = selectedCategory == "All" ? faqs : faqs.filter { $0.category == selectedCategory }
        
        if searchText.isEmpty {
            return categoryFiltered
        } else {
            return categoryFiltered.filter { faq in
                faq.question.localizedCaseInsensitiveContains(searchText) ||
                faq.answer.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    public var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                headerSection
                searchSection
                categorySection
                faqListSection
            }
            .padding(.horizontal)
            .padding(.bottom, 100)
        }
        .onTapGesture {
            hideKeyboard()
        }
        .background(Color("BackgroundColorx"))
        .toolbarBackground(.visible, for: .navigationBar)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                            .fontWeight(.semibold)
                        Text("Back")
                    }
                }
                .foregroundColor(Color("primary_1"))
            }
        }
    }
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                ZStack {
                    Circle()
                        .fill(Color("primary_1").opacity(0.2))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: "questionmark.circle.fill")
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(Color("primary_1"))
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Frequently Asked Questions")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text("Find answers to common questions")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
        }
        .padding(.vertical)
        .padding(.horizontal)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
        .padding(.top, 16)
    }
    
    private var searchSection: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("Search FAQ...", text: $searchText)
                .textFieldStyle(PlainTextFieldStyle())
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
    
    private var categorySection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(categories, id: \.self) { category in
                    CategoryButton(
                        title: category,
                        isSelected: selectedCategory == category
                    ) {
                        hideKeyboard()
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            selectedCategory = category
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
    }
    
    private var faqListSection: some View {
        LazyVStack(spacing: 12) {
            ForEach(filteredFAQs) { faq in
                FAQItem(
                    faq: faq,
                    isExpanded: expandedItems.contains(faq.id)
                ) {
                    hideKeyboard()
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                        if expandedItems.contains(faq.id) {
                            expandedItems.remove(faq.id)
                        } else {
                            expandedItems.insert(faq.id)
                        }
                    }
                }
            }
        }
    }
}

struct CategoryButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(isSelected ? Color("primary_1") : Color.gray.opacity(0.1))
                )
                .foregroundColor(isSelected ? .white : .primary)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct FAQItem: View {
    let faq: FAQ
    let isExpanded: Bool
    let onTap: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button(action: onTap) {
                HStack {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(faq.question)
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.leading)
                        
                        Text(faq.category)
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(Color("primary_1"))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(Color("primary_1").opacity(0.1))
                            .cornerRadius(4)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.down")
                        .font(.system(.callout, weight: .medium))
                        .foregroundColor(Color("primary_1"))
                        .rotationEffect(.degrees(isExpanded ? 180 : 0))
                        .animation(.spring(response: 0.3), value: isExpanded)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
            }
            .buttonStyle(PlainButtonStyle())
            
            if isExpanded {
                VStack(alignment: .leading, spacing: 8) {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 1)
                        .padding(.horizontal, 16)
                    
                    Text(faq.answer)
                        .font(.body)
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 16)
                        .padding(.bottom, 16)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .transition(.asymmetric(
                    insertion: .opacity.combined(with: .move(edge: .top)),
                    removal: .opacity.combined(with: .move(edge: .top))
                ))
            }
        }
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

#Preview {
    NavigationView {
        FaqDetail()
    }
}
