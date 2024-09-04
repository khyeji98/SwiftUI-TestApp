//
//  DocumentView.swift
//  Tester
//
//  Created by 김혜지 on 8/8/24.
//

import PDFKit
import SwiftUI

struct PDFKitView: UIViewRepresentable {
    private let url: URL
    
    init(url: URL) {
        self.url = url
    }
    
    func makeUIView(context: Context) -> some UIView {
        let pdfView = PDFView()
        pdfView.document = PDFDocument(url: url)
        pdfView.autoScales = true
        return pdfView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {}
}

struct DocumentView: View {
    private let networkManager: NetworkManager = NetworkManager()
    private let url: URL?// = URL(string: "https://studyinthestates.dhs.gov/sites/default/files/Form%20I-20%20SAMPLE.pdf")!
    
    @State private var isPresentedDocumentImage: Bool = false
    
    init() {
        if let path = Bundle.main.path(forResource: "금전소비대차계약서_양식_v0", ofType: "docx") {
            self.url = URL(filePath: path)
        } else {
            self.url = nil
        }
    }
    
    var body: some View {
        VStack {
            Spacer()
            HStack(spacing: 50) {
                Button("다운로드하기") {
                    download()
                }
                
                Button("이미지로 변환하기") {
                    isPresentedDocumentImage = true
                }
            }
            Spacer()
            if let url = url {
                PDFKitView(url: url)
            }
            Spacer()
        }
        .sheet(isPresented: $isPresentedDocumentImage, content: {
            if let uiImage = convertToImage() {
                Image(uiImage: uiImage).resizable().scaledToFit().gesture(magnification).scaleEffect(magnifyBy)
            }
        })
    }
    
    @State private var magnifyBy = 1.0
    
    var magnification: some Gesture {
        MagnificationGesture(minimumScaleDelta: .zero)
            .onChanged { value in
                magnifyBy = value.magnitudeSquared
            }
    }
    
    private func download() {
        guard let url = url else { return }
        Task {
            try? await networkManager.request(url: url)
        }
    }
    
    private func convertToImage() -> UIImage? {
        guard let url = url, let pdfDocument = PDFDocument(url: url), let firstPage = pdfDocument.page(at: 0) else { return nil }
        let rect = firstPage.bounds(for: .mediaBox)
        let renderer = UIGraphicsImageRenderer(size: rect.size)
        let image = renderer.image { context in
            firstPage.draw(with: .mediaBox, to: context.cgContext)
        }
        return image
    }
}

extension DocumentView {
    final class NetworkManager: NSObject, URLSessionDownloadDelegate, URLSessionTaskDelegate {
        func request(url: URL) async throws {
            let urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
            let task = urlSession.downloadTask(with: .init(url: url))
            task.resume()
        }
        
        func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
            guard let url = downloadTask.originalRequest?.url else { return }
            let path = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
            let destinationURL = path.appendingPathComponent(url.lastPathComponent)
            try? FileManager.default.removeItem(at: destinationURL)
            do {
                try FileManager.default.copyItem(at: location, to: destinationURL)
                print("destinationURL: ", destinationURL)
            } catch {
                print("error: ", error.localizedDescription)
            }
        }
    }
}

#Preview {
    DocumentView()
}
