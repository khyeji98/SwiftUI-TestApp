//
//  HighlightView.swift
//  Tester
//
//  Created by 김혜지 on 6/17/24.
//

import SwiftUI

struct ViewOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = .zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}


struct HighlightView: View {
    @State private var isHighlighted: Bool = true
    @State private var y: CGFloat = .zero
    
    init() {}
    
    var body: some View {
        ZStack {
            containerView
            
            contentView
            
            highlightView
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .ignoresSafeArea()
        .onPreferenceChange(ViewOffsetKey.self) { y in
            print("y: ", y)
            self.y = y - UIScreen.main.bounds.height / 2
        }
    }
    
    private var containerView: some View {
        VStack(spacing: .zero) {
            topLabel
            
            Spacer()
            
            button3
        }
    }
    
    private var contentView: some View {
        VStack(spacing: 10) {
            Spacer()
            
            GeometryReader { geometry in
                button1.preference(key: ViewOffsetKey.self, value: geometry.frame(in: .global).midY)
            }
            .frame(height: 50)
            
            button2
            
            Spacer()
        }
        .padding(.vertical, 50)
    }
    
    @ViewBuilder
    private var highlightView: some View {
        if isHighlighted {
            Color.black.opacity(0.5)
            
            Text("아래 버튼을 눌러\n카카오톡에서 본인인증을 해주세요").foregroundStyle(.white).offset(x: .zero, y: y - 56 / 2 - 17 * 2)
            button1.offset(x: .zero, y: y)
        }
    }
    
    private var topLabel: some View {
        Color.orange.frame(height: 50)
    }
    
    private var button1: some View {
        Button(action: {}, label: {
            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(.green)
        })
        .frame(height: 50)
        .padding(.horizontal, 20)
    }
    
    private var button2: some View {
        Button(action: {
            
        }, label: {
            ZStack {
                RoundedRectangle(cornerRadius: 10).foregroundStyle(.blue)
                
                RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 1).foregroundStyle(.orange)
            }
        })
        .frame(height: 50)
        .padding(.horizontal, 20)
    }
    
    private var button3: some View {
        Button(action: {}, label: {
            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(.orange)
        })
        .frame(height: 50)
        .padding(.horizontal, 20)
    }
}

private extension View {
    @ViewBuilder
    func reverseMask<Mask: View>(
        alignment: Alignment = .center,
        @ViewBuilder _ mask: () -> Mask
    ) -> some View {
        self.mask {
            Rectangle()
                .overlay(alignment: alignment) {
                    mask()
                        .blendMode(.destinationOut)
                }
        }
    }
}

#Preview {
    HighlightView()
}
