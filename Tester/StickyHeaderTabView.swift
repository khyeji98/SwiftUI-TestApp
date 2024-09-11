//
//  StickyHeaderTabView.swift
//  Tester
//
//  Created by 김혜지 on 8/5/24.
//

import SwiftUI

private enum Destination: Hashable {
    case sub1OfTab1
    case sub2OfTab1
    
    @ViewBuilder
    var view: some View {
        switch self {
        case .sub1OfTab1:
            VStack {
                Button("다음뷰로!") {
                    Coordinator.shared.navigateTo(.sub2OfTab1)
                }
                Text("Tab1에서 SubView1")
            }
        case .sub2OfTab1:
            VStack {
                Button("가장처음으로!") {
                    Coordinator.shared.popToRoot()
                }
                Button("탭뷰아님으로 변경!") {
                    Coordinator.shared.isTabView = false
                    Coordinator.shared.popToRoot()
                }
                Text("Tab1에서 SubView1")
            }
            .background(Color.green)
        }
    }
}

private final class Coordinator: ObservableObject {
    static let shared: Coordinator = Coordinator()
    @Published var paths: NavigationPath = .init()
    @Published var isTabView: Bool = true
    
    func navigateTo(_ path: Destination) {
        paths.append(path)
    }
    
    func popToRoot() {
        paths = .init()
    }
}

struct StickyHeaderTabView: View {
    @StateObject private var coordinator: Coordinator = Coordinator.shared
    @State private var selectedTab: Int = .zero
    
    init() {}
    
    var body: some View {
            NavigationStack(path: $coordinator.paths) {
                Group {
                    if coordinator.isTabView {
                        TabView(selection: $selectedTab) {
                            tab1
                            tab2
                            tab3
                            tab4
                        }
                    } else {
                        VStack {
                            Button("다시탭뷰로!") {
                                Coordinator.shared.isTabView = true
                            }
                            Text("탭뷰 아님!")
                        }
                    }
                }
                .navigationDestination(for: Destination.self) { path in
                    path.view
                }
            }
            .navigationBarBackButtonHidden()
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
        .tabItem { Text("Tab 1") }
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
        .tabItem { Text("Tab 2") }
    }
    
    private var tab3: some View {
        ScrollView {
            VStack {
                TopBar()
                
                Tab3()
            }
        }
        .tag(2)
        .tabItem { Text("Tab 3") }
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
        .tabItem { Text("Tab 4") }
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
        final class ViewModel: ObservableObject {
            @Published var isCalled: Bool = false
            
            init() { task() }
            
            func task() {
                print("태스크!")
                isCalled = true
            }
        }
        
        @StateObject private var viewModel: ViewModel = ViewModel()
        
        var body: some View {
            ZStack {
                Color.red.frame(minHeight: UIScreen.main.bounds.height)
                
                VStack {
                    Text("task() is called? \(viewModel.isCalled)")
                    Button("다음뷰로!") {
                        Coordinator.shared.navigateTo(.sub1OfTab1)
                    }
                }
            }
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
                    
                    Text("Sticky Top Bar")
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
