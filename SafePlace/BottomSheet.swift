//
//  BottomSheet.swift
//  SafePlace
//
//  Created by Mariarita Patrelli on 17/12/24.
//


//import SwiftUI
//
//struct BottomSheet<Content: View>: View {
//    let content: Content
//    @GestureState private var dragOffset = CGSize.zero
//    @State private var currentOffsetY: CGFloat = UIScreen.main.bounds.height * 0.1
//    @Binding var showModal: Bool  // Bind to track modal visibility
//
//    init(showModal: Binding<Bool>, @ViewBuilder content: () -> Content) {
//        self._showModal = showModal
//        self.content = content()
//    }
//
//    var body: some View {
//        VStack(spacing: 0) {
//            Capsule()
//                .fill(Color.gray)
//                .frame(width: 40, height: 6)
//                .padding(.top, 8)
//
//            content
//                .background(Color.white)
//                .cornerRadius(16)
//                .shadow(radius: 10)
//        }
//        .background(Color.white.opacity(0.8))
//        .offset(y: showModal ? currentOffsetY : UIScreen.main.bounds.height)
//        .gesture(
//            DragGesture()
//                .updating($dragOffset) { value, state, _ in
//                    state = value.translation
//                }
//                .onEnded { value in
//                    let maxHeight = UIScreen.main.bounds.height * 0.4
//                    let minHeight: CGFloat = 50
//                    currentOffsetY = max(minHeight, min(maxHeight, currentOffsetY + value.translation.height))
//                }
//        )
//        .animation(.easeInOut, value: showModal)
//    }
//}

import SwiftUI

struct BottomSheet<Content: View>: View {
    let content: Content
    @Binding var showModal: Bool  // Bind the showModal to control visibility

    init(showModal: Binding<Bool>, @ViewBuilder content: () -> Content) {
        self._showModal = showModal
        self.content = content()
    }

    var body: some View {
        VStack(spacing: 0) {
            Capsule()
                .fill(Color.gray)
                .frame(width: 40, height: 6)
                .padding(.top, 8)

            content
                .background(Color.white)
                .cornerRadius(16)
                .shadow(radius: 10)
        }
        .background(Color.white.opacity(0.8))
        .offset(y: showModal ? 0 : UIScreen.main.bounds.height)  // Move the sheet based on visibility
        .animation(.easeInOut, value: showModal)
    }
}
