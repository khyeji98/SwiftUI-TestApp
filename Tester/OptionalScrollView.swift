//
//  OptionalScrollView.swift
//  Tester
//
//  Created by 김혜지 on 9/24/24.
//

import SwiftUI

struct OptionalScrollView: View {
    var body: some View {
        ScrollView {
            VStack {
                Text("스크롤 뷰")
            }
        }
        .refreshable {}
        .scrollDisabled(true)
    }
}

#Preview {
    OptionalScrollView()
}
