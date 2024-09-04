//
//  NestedViewModel.swift
//  Tester
//
//  Created by 김혜지 on 8/12/24.
//

import Combine
import SwiftUI

final class MainViewModel: ObservableObject {
    var isPresentedSheet: Bool {
        subViewModel.someValue
    }
    let subViewModel: SubViewModel = SubViewModel()
    
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
//        subViewModel.$isPresentedSheet.sink(receiveValue: togglePresentingSheet(_:)).store(in: &cancellables)
//        subViewModel.publisher.sink(receiveValue: presentSheet).store(in: &cancellables)
subViewModel.objectWillChange.sink(receiveValue: { 
            print("바뀜 \(self.subViewModel.someValue)")
        }).store(in: &cancellables)
    }
    
//    private func togglePresentingSheet(_ isPresented: Bool) {
//        DispatchQueue.main.async {
//            self.isPresentedSheet = isPresented
//        }
//    }
//
//    private func presentSheet() {
//        DispatchQueue.main.async {
//            self.isPresentedSheet = true
//        }
//    }
}

final class SubViewModel: ObservableObject {
    @Published var isPresentedSheet: Bool = false
    var someValue: Bool { isPresentedSheet }
    
    let publisher: PassthroughSubject<Void, Never> = .init()
    
    func presentSheet() {
        isPresentedSheet = true
    }
    
    func sendEvent() {
        publisher.send()
    }
}

struct MainView: View {
    @StateObject private var viewModel: MainViewModel = MainViewModel()
    
    var body: some View {
        ZStack {
            Color.orange.ignoresSafeArea()
            
            SubView(viewModel: viewModel.subViewModel)
            
            VStack {
                Text("isPresentedSheet? \(viewModel.isPresentedSheet)")
                    .foregroundStyle(.white)
                
                Spacer()
            }
        }
    }
    
    struct SubView: View {
        @StateObject private var viewModel: SubViewModel
        
        init(viewModel: SubViewModel) {
            self._viewModel = StateObject(wrappedValue: viewModel)
        }
        
        var body: some View {
            ZStack {
                Color.black
                
                Button("Present Sheet!", action: viewModel.presentSheet)
            }
        }
    }
}
