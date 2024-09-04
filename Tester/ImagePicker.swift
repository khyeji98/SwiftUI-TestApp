//
//  ImagePicker.swift
//  Tester
//
//  Created by 김혜지 on 8/23/24.
//

import PhotosUI
import SwiftUI

struct ImageItem: Hashable {
    let index: Int
    let uiImage: UIImage
}

class ImagePickerViewModel: ObservableObject {
    @Published var isPresentedGallery: Bool = false
    @Published var isPresentedCamera: Bool = false
    
    @Published private(set) var imageItems: [ImageItem] = []
    @Published var cameraImages: [Data] = [] {
        didSet { setImageItems() }
    }
    @Published var photosPickerItems: [PhotosPickerItem] = [] {
        didSet {
            Task {
                await setGalleryImages()
                setImageItems()
            }
        }
    }
    private var galleryImages: [UIImage] = []
    
    private func loadTransferable(_ photosPickerItem: PhotosPickerItem) async -> UIImage? {
        guard let data = try? await photosPickerItem.loadTransferable(type: Data.self), let uiImage = UIImage(data: data) else { return nil }
        return uiImage
    }
    
    private func setGalleryImages() async {
        galleryImages.removeAll()
        for photosPickerItem in photosPickerItems {
            if let uiImage = await loadTransferable(photosPickerItem) {
                galleryImages.append(uiImage)
            }
        }
    }
    
    private func setImageItems() {
        DispatchQueue.main.async {
            self.imageItems = (self.cameraImages.compactMap({UIImage(data: $0)}) + self.galleryImages).enumerated().map({ ImageItem(index: $0.offset, uiImage: $0.element) })
        }
    }
    
    func remove(at index: Int) {
        if cameraImages.indices.contains(index) {
            cameraImages.remove(at: index)
        } else {
            photosPickerItems.remove(at: index)
        }
    }
}

struct ImagePickerView: View {
    @StateObject private var viewModel: ImagePickerViewModel = ImagePickerViewModel()
    @State private var isScrollView: Bool = false
    
    var body: some View {
        VStack {
            Toggle(isOn: $isScrollView, label: {
                Text("is ScrollView?")
            })
            
            HStack {
                Button("카메라로 사진 찍기", action: { viewModel.isPresentedCamera = true })
                Button("갤러리에서 사진 추가", action: { viewModel.isPresentedGallery = true })
            }
            
            if isScrollView {
                ScrollView(.horizontal) {
                    LazyHStack(spacing: 25) {
                        ForEach(viewModel.imageItems, id: \.self) { item in
                            Image(uiImage: item.uiImage)
                                .resizable()
                                .frame(width: UIScreen.main.bounds.width - ( 60 * 2), height: UIScreen.main.bounds.width - ( 60 * 2))
                                .scaledToFill()
                                .onTapGesture {
                                    viewModel.remove(at: item.index)
                                }
                        }
                    }
                    .padding(.horizontal, 60)
                    .background(GeometryReader(content: { geometry in
                        Color.clear.onChange(of: geometry.frame(in: .global).minX, perform: { minX in
                            print("minX: ", minX)
                        })
                    }))
                }
            } else {
                GeometryReader { geometry in
                    TabView {
                        ForEach(viewModel.imageItems, id: \.self) { item in
                            Image(uiImage: item.uiImage)
                                .resizable()
                                .frame(width: UIScreen.main.bounds.width - ( 60 * 2), height: UIScreen.main.bounds.width - ( 60 * 2))
                                .scaledToFill()
                                .onTapGesture {
                                    viewModel.remove(at: item.index)
                                }
                        }
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    .frame(height: geometry.size.height - 100)
                }
            }
        }
        .fullScreenCover(isPresented: $viewModel.isPresentedCamera, content: {
            CameraView(isPresented: $viewModel.isPresentedCamera, capturedAction: { viewModel.cameraImages.append($0) })
        })
        .photosPicker(
            isPresented: $viewModel.isPresentedGallery,
            selection: $viewModel.photosPickerItems,
            maxSelectionCount: 10,
            matching: .images,
            preferredItemEncoding: .automatic
        )
        .onAppear {
            UIScrollView.appearance().isPagingEnabled = true
        }
        .onDisappear {
            UIScrollView.appearance().isPagingEnabled = false
        }
    }
}

struct CameraView: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    
    private let capturedAction: (Data) -> Void
    
    init(isPresented: Binding<Bool>, capturedAction: @escaping (Data) -> Void) {
        self._isPresented = isPresented
        self.capturedAction = capturedAction
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .camera
        picker.cameraCaptureMode = .photo
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    final class Coordinator: NSObject {
        private let parent: CameraView
        
        init(parent: CameraView) {
            self.parent = parent
        }
    }
}

extension CameraView.Coordinator: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let uiImage = info[.originalImage] as? UIImage, let imageData = uiImage.jpegData(compressionQuality: 0.8) {
            parent.capturedAction(imageData)
        }
        parent.isPresented = false
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        parent.isPresented = false
    }
    
    func navigationControllerSupportedInterfaceOrientations(_ navigationController: UINavigationController) -> UIInterfaceOrientationMask {
        return .portrait
    }
}
