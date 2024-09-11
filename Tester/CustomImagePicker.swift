//
//  CustomImagePicker.swift
//  Tester
//
//  Created by 김혜지 on 9/2/24.
//

import SwiftUI

final class CustomImagePickerViewModel: ImagePickerViewModel {
}

struct CustomImagePickerView: View {
    @StateObject private var viewModel: CustomImagePickerViewModel = CustomImagePickerViewModel()
    
    var body: some View {
        VStack {
            Text("CustomImagePickerView")
                .onTapGesture {
                    let data = viewModel.makeDatas()
                    print(data)
                }
            
            ImagePickerView()
        }
    }
}
