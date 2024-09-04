//
//  LineGraph.swift
//  Tester
//
//  Created by 김혜지 on 8/21/24.
//

import SwiftUI

struct LineGraph: View {
    private let color: Color
    private let maxHeight: CGFloat
    private let horizontalPadding: CGFloat
    
    private let data: [LineGraphData]
    private var maxValue: Double { data.max(by: { $0.value < $1.value })!.value }
    
    init(color: Color = .green, maxHeight: CGFloat = 100, horizontalPadding: CGFloat = 25, data: [LineGraphData] = SpyLineGraphData.mock()) {
        self.color = color
        self.maxHeight = maxHeight
        self.horizontalPadding = horizontalPadding
        self.data = data
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                let spacing = (geometry.size.width - (horizontalPadding * 2)) / CGFloat(data.count - 1)
                Path { path in
                    path.move(to: CGPoint(x: 0, y: toYPoint(data[0].value)))
                    
                    for index in data[1...].indices {
                        path.addLine(to: CGPoint(x: spacing * CGFloat(index), y: toYPoint(data[index].value)))
                    }
                    path.addLine(to: CGPoint(x: geometry.size.width, y: 500))
                }
                .stroke(.blue, style: StrokeStyle(lineWidth: 2))
                .rotationEffect(.degrees(180), anchor: .center)
                .rotation3DEffect(.degrees(180), axis: (x: 0.0, y: 1.0, z: 0.0))
                
                
                HStack(spacing: spacing) {
                    ForEach(data) { item in
                        VStack {
                            ZStack {
                                Circle().frame(width: 15, height: 15).foregroundStyle(.red)
                                Circle().frame(width: 7, height: 7).foregroundStyle(.white)
                            }
                        }
                    }
                }
            }
        }
        .padding(.horizontal, horizontalPadding)
    }
    
    private var point: some View {
        ZStack {
            Circle()
                .foregroundStyle(color)
                .frame(width: 10, height: 10)
            
            Circle()
                .foregroundStyle(.white)
                .frame(width: 8, height: 8)
        }
    }
    
    private func toYPoint(_ value: Double) -> CGFloat {
        return value / maxValue * maxHeight
    }
}

class LineGraphData: Identifiable {
    let label: String
    let value: Double
    
    init(label: String, value: Double) {
        self.label = label
        self.value = value
    }
}

private final class SpyLineGraphData: LineGraphData {
    static func mock() -> [SpyLineGraphData] {
        return [
            SpyLineGraphData(label: "label1", value: 10000),
            SpyLineGraphData(label: "label2", value: 20000),
            SpyLineGraphData(label: "label3", value: 40000),
            SpyLineGraphData(label: "label4", value: 40000),
            SpyLineGraphData(label: "label5", value: 50000),
            SpyLineGraphData(label: "label6", value: 20000),
            SpyLineGraphData(label: "label7", value: 70000),
            SpyLineGraphData(label: "label8", value: 80000),
            SpyLineGraphData(label: "label9", value: 90000),
            SpyLineGraphData(label: "label10", value: 100000)
        ]
    }
}

#Preview {
    LineGraph()
}
