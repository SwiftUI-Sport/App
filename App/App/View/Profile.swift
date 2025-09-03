//
//  Profile.swift
//  App
//
//  Created by Ali An Nuur on 03/09/25.
//

import SwiftUI

struct ProfileView: View {
    @StateObject private var router = ProfileFlowRouter()
    
    var body: some View {
        NavigationStack(path: $router.navPaths) {
            mainView
                .navigationDestination(for: ProfileFlow.self) { destination in
                    destination.destinationView
                        .navigationTitle(destination.title)
                        .toolbarRole(.automatic)
                }
        }
        .environmentObject(router)
    }
    
    private var mainView: some View {
        ScrollView {
            VStack(spacing: 0) {
                headerView
                
                VStack(spacing: 16) {
                    ProfileMenuItem(
                        icon: "questionmark.circle.fill",
                        title: "Frequently Asked Questions",
                        subtitle: "Get answers to common questions",
                        color: Color("primary_1")
                    ) {
                        router.navigate(to: .faq)
                    }
                    
                    Spacer(minLength: 100)
                }
                .padding(.horizontal)
                .padding(.top, 20)
            }
        }
        .background(Color("BackgroundColorx"))
        .navigationBarHidden(true)
    }
    
    private var headerView: some View {
//        ZStack(alignment: .bottomLeading) {
//            LinearGradient(
//                gradient: Gradient(colors: [
//                    Color("primary_1"),
//                    Color("primary_1").opacity(0.8)
//                ]),
//                startPoint: .topLeading,
//                endPoint: .bottomTrailing
//            )
//            .frame(height: 200)
//            .clipShape(
//                .rect(
//                    topLeadingRadius: 0,
//                    bottomLeadingRadius: 25,
//                    bottomTrailingRadius: 25,
//                    topTrailingRadius: 0
//                )
//            )
//            
//            BlobHeaderShape()
            
            VStack(alignment: .leading, spacing: 8) {
//                HStack {
//                    ZStack {
//                        Circle()
//                            .fill(Color.gray.opacity(0.2))
//                            .frame(width: 60, height: 60)
//                        
//                        Image(systemName: "person.fill")
//                            .font(.system(size: 30, weight: .medium))
//                            .foregroundColor(.gray)
//                    }
//                    
//                    Spacer()
//                }
                
                Text("Profile")
                    .font(.system(.largeTitle, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundColor(Color("primary_1"))
                
                Text("Manage your account and preferences")
                    .font(.headline)
                    .foregroundColor(.gray.opacity(0.8))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
            .padding(.bottom, 10)
        }
//    }
}

struct ProfileMenuItem: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                action()
            }
        }) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.15))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: icon)
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(color)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(.callout, weight: .semibold))
                    .foregroundColor(color)
                    .scaleEffect(isPressed ? 1.2 : 1.0)
                    .animation(.spring(response: 0.3), value: isPressed)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
            .scaleEffect(isPressed ? 0.98 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                isPressed = pressing
            }
        }, perform: {})
    }
}

#Preview {
    ProfileView()
}
