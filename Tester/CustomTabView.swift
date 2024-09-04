//
//  CustomTabView.swift
//  Tester
//
//  Created by 김혜지 on 9/3/24.
//

import SwiftUI

struct CustomTabView: View {
    enum Tab {
        case one
        case two
        case three
        case four
    }
    
    @State private var selectedTab: Tab = .one
    
    var body: some View {
        switch selectedTab {
        case .one:
            oneView
        case .two:
            twoView
        case .three:
            threeView
        case .four:
            fourView
        }
    }
    
    private var oneView: some View {
        Text("첫번째 뷰")
    }
    
    private var twoView: some View {
        Text("두번째 뷰")
    }
    
    private var threeView: some View {
        Text("세번째 뷰")
    }
    
    private var fourView: some View {
        Text("네번째 뷰")
    }
}
