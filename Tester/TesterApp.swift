//
//  TesterApp.swift
//  Tester
//
//  Created by 김혜지 on 6/17/24.
//

import SwiftUI

@main
struct TesterApp: App {
    @State private var isPresented: Bool = false
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {
    var body: some View {
        NavigationView {
            List(Test.allCases, id: \.self) { row in
                NavigationLink(row.rawValue, destination: { row.view })
            }
        }
    }
}

private enum Test: String, CaseIterable {
    case tabView
    case datePicker
    case nestedViewModel
    case pdfDocument
    case lineGraph
    case imagePicker
    case layout
    
    @ViewBuilder
    var view: some View {
        switch self {
        case .tabView:
            StickyHeaderTabView()
        case .datePicker:
            CustomDatePickerView()
        case .nestedViewModel:
            MainView()
        case .pdfDocument:
            DocumentView()
        case .lineGraph:
            LineGraph()
        case .imagePicker:
            ImagePickerView()
        case .layout:
            LayoutBreakView()
        }
    }
}

#Preview {
    ContentView()
}
