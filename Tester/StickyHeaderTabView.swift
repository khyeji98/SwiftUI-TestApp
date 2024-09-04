//
//  StickyHeaderTabView.swift
//  Tester
//
//  Created by 김혜지 on 8/5/24.
//

import SwiftUI

struct StickyHeaderTabView: View {
    @State private var selectedTab: Int = .zero
    
    init() {}
    
    var body: some View {
        TabView(selection: $selectedTab) {
            tab1
            tab2
            tab3
            tab4
        }
    }
    
    private var tab1: some View {
        ScrollView {
            LazyVStack(spacing: .zero, pinnedViews: .sectionHeaders) {
                Section {
                    Tab1()
                } header: {
                    TopBar()
                }
            }
        }
        .tag(0)
    }
    
    private var tab2: some View {
        ScrollView {
            LazyVStack(spacing: .zero, pinnedViews: .sectionHeaders) {
                Section {
                    Tab2()
                } header: {
                    TopBar()
                }
            }
        }
        .tag(1)
    }
    
    private var tab3: some View {
        ScrollView {
            VStack {
                TopBar()
                
                Tab3()
            }
        }
        .tag(2)
    }
    
    private var tab4: some View {
        ScrollView {
            LazyVStack(spacing: .zero, pinnedViews: .sectionHeaders) {
                Section {
                    Tab4()
                } header: {
                    TopBar()
                }
            }
        }
        .tag(3)
    }
    
    struct TopBar: View {
        var body: some View {
            HStack {
                Spacer()
                
                Text("Top Bar")
                    .bold()
            }
            .padding(.vertical, 20)
            .background(.white)
        }
    }
    
    struct Tab1: View {
        var body: some View {
            Color.red.frame(minHeight: UIScreen.main.bounds.height)
        }
    }
    
    struct Tab2: View {
        var body: some View {
            Color.orange.frame(minHeight: UIScreen.main.bounds.height)
        }
    }
    
    struct Tab3: View {
        var body: some View {
            LazyVStack(spacing: .zero, pinnedViews: .sectionHeaders) {
                Section {
                    Color.yellow.tag(2).frame(minHeight: UIScreen.main.bounds.height)
                } header: {
                    SubTopBar()
                }
            }
        }
        
        struct SubTopBar: View {
            var body: some View {
                HStack {
                    Spacer()
                    
                    Text("Sub Top Bar")
                        .bold()
                }
                .padding(.vertical, 20)
                .background(.white)
            }
        }
    }
    
    struct Tab4: View {
        var body: some View {
            Color.green.frame(minHeight: UIScreen.main.bounds.height)
        }
    }
}

#Preview {
    StickyHeaderTabView()
}
