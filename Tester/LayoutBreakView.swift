//
//  LayoutBreakView.swift
//  Tester
//
//  Created by 김혜지 on 9/3/24.
//

import SwiftUI

struct LayoutBreakView: View {
    private let screenHeight: CGFloat = UIScreen.main.bounds.height
    @State private var isGreen: Bool = true
    
    var body: some View {
        VStack(spacing: 0) {
            Color.black.frame(height: 44)
            
//            Color.orange.overlay {
//                overlayView
//            }
            Color.orange.overlayIfNeeds($isGreen) {
                overlayView
            }
        }
        .ignoresSafeArea()
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.isGreen = false
            }
        }
    }
    
    private var overlayView: some View {
        Color.green.opacity(0.2).ignoresSafeArea()
    }
}

extension View {
    func overlayIfNeeds<Content: View>(_ isPresented: Binding<Bool>, @ViewBuilder content: @escaping () -> Content) -> some View {
        modifier(OverlayIfNeedsModifier(isPresented: isPresented, overlayView: content))
    }
}

struct OverlayIfNeedsModifier<OverlayView: View>: ViewModifier {
    @Binding var isPresented: Bool
    
    private let overlayView: OverlayView
    
    init(
        isPresented: Binding<Bool>,
        @ViewBuilder overlayView: @escaping () -> OverlayView
    ) {
        self._isPresented = isPresented
        self.overlayView = overlayView()
    }
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            if isPresented {
                overlayView.ignoresSafeArea()
            }
        }
    }
}

#Preview {
    LayoutBreakView()
}
