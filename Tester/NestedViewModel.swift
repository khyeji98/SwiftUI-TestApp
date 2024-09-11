//
//  NestedViewModel.swift
//  Tester
//
//  Created by 김혜지 on 8/12/24.
//

import Combine
import SwiftUI

enum SubContent: Int {
    case sub1, sub2, sub3
}

final class MainViewModel: ObservableObject {
    @Published private(set) var currentContent: SubContent = .sub1
    var status: Bool {
        switch currentContent {
        case .sub1:
            return subVM1.extraStatus
        case .sub2:
            return subVM2.extraStatus
        case .sub3:
            return subVM3.extraStatus
        }
    }
    var value: Int {
        switch currentContent {
        case .sub1:
            return subVM1.value
        case .sub2:
            return subVM2.value
        case .sub3:
            return subVM3.value
        }
    }
    let subVM1: SubViewModel = SubViewModel()
    let subVM2: SubViewModel = SubViewModel()
    let subVM3: SubViewModel = SubViewModel()
    
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
//        subVM1.publisher.sink(receiveValue: goToNextSubView).store(in: &cancellables)
//        subVM2.publisher.sink(receiveValue: goToNextSubView).store(in: &cancellables)
//        subVM1.$status.sink(receiveValue: { _ in self.goToNextSubView() }).store(in: &cancellables)
//        subVM1.objectWillChange.sink(receiveValue: { self.objectWillChange.send() }).store(in: &cancellables)
        Publishers.CombineLatest(subVM1.$status, subVM1.$value).sink(receiveValue: { _ in self.objectWillChange.send() }).store(in: &cancellables)
    }
    
    private func goToNextSubView() {
        guard let nextSubCotnent = SubContent(rawValue: currentContent.rawValue + 1) else { return }
        currentContent = nextSubCotnent
    }
}

final class SubViewModel: ObservableObject {
    @Published var status: Bool = false
    @Published var value: Int = 0
    private(set) var extraStatus: Bool = false
    
    let publisher: PassthroughSubject<Void, Never> = .init()
    
    func toggleStatus() {
        status.toggle()
    }
    
    func toggleExtraStatus() {
//        status.toggle()
        value += 1
        extraStatus.toggle()
    }
    
    func sendEvent() {
        publisher.send()
    }
}

struct MainView: View {
    @StateObject private var viewModel: MainViewModel = MainViewModel()
    
    init() {}
    
    var body: some View {
        ZStack {
            Color.orange.ignoresSafeArea()
            
            switch viewModel.currentContent {
            case .sub1:
                SubView(viewModel: viewModel.subVM1, color: .black)
            case .sub2:
                SubView(viewModel: viewModel.subVM2, color: .blue)
            case .sub3:
                SubView(viewModel: viewModel.subVM3, color: .yellow)
            }
            
            VStack {
                Spacer()
                Text("current SubView's status? \(viewModel.status)").foregroundStyle(.white)
                Text("current SubView's value? \(viewModel.value)").foregroundStyle(.white)
                Spacer()
                Spacer()
            }
        }
    }
    
    struct SubView: View {
        @StateObject private var viewModel: SubViewModel
        
        private let color: Color
        
        init(viewModel: SubViewModel, color: Color) {
            self._viewModel = StateObject(wrappedValue: viewModel)
            self.color = color
        }
        
        var body: some View {
            ZStack {
                color
                
                VStack(spacing: 20) {
                    Spacer()
                    Spacer()
                    Button("Toggle Status!", action: viewModel.toggleStatus)
                    Button("Toggle Extra Status!", action: viewModel.toggleExtraStatus)
                    Button("Next SubView!", action: viewModel.sendEvent)
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    MainView()
}
