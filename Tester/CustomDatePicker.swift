//
//  CustomDatePicker.swift
//  Tester
//
//  Created by 김혜지 on 7/24/24.
//

import SwiftUI

struct CustomDatePickerView: View {
    @State private var isFullDatePicker: Bool = false
    @State private var year: Int
    @State private var month: Int
    @State private var day: Int?
    
    init() {
        let now = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        year = now.year ?? 0
        month = now.month ?? 0
        day = now.day
    }
    
    var body: some View {
        VStack {
            Toggle("Full Date?", isOn: $isFullDatePicker)
            Text("\(year)년 \(month)월 \(day)일")
            CustomDatePicker(isFullDatePicker ? .fullDate : .dateExcludedDay, year: $year, month: $month, day: $day)
        }
    }
}

extension CustomDatePicker {
    enum PickerType {
        case dateExcludedDay
        case fullDate
        
        var components: [Component] {
            switch self {
            case .dateExcludedDay:
                return [.year, .month]
            case .fullDate:
                return [.year, .month, .day]
            }
        }
    }
    
    enum Component: Int {
        case year = 0
        case month
        case day
        
        static var years: [Int] {
            let currentYear = Calendar.current.component(.year, from: .now)
            return Array(currentYear-7...currentYear+7)
        }
        static var months: [Int] { Array(1...12) }
        static func daysInMonths(year: Int, month: Int) -> [Int] {
            let dateComponents = DateComponents(year: year, month: month)
            let date = Calendar.current.date(from: dateComponents)!
            let range = Calendar.current.range(of: .day, in: .month, for: date)!
            return range.map({ $0 })
        }
    }
}

struct CustomDatePicker: UIViewRepresentable {
    private let pickerType: PickerType
    
    @Binding var year: Int
    @Binding var month: Int
    @Binding var day: Int?
    
    init(_ pickerType: PickerType, year: Binding<Int>, month: Binding<Int>, day: Binding<Int?>) {
        self.pickerType = pickerType
        self._year = year
        self._month = month
        self._day = day
    }
    
    func makeUIView(context: Context) -> some UIView {
        let pickerView = UIPickerView()
        pickerView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        pickerView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.dataSource = context.coordinator
        pickerView.delegate = context.coordinator
        if let selectedYearRow = Component.years.firstIndex(of: year) {
            pickerView.selectRow(selectedYearRow, inComponent: Component.year.rawValue, animated: false)
        }
        if let selectedMonthRow = Component.months.firstIndex(of: month) {
            pickerView.selectRow(selectedMonthRow, inComponent: Component.month.rawValue, animated: false)
        }
        if let day = day, let selectedDayRow = Component.daysInMonths(year: year, month: month).firstIndex(of: day) {
            pickerView.selectRow(selectedDayRow, inComponent: Component.day.rawValue, animated: false)
        }
        return pickerView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(pickerType: pickerType, year: $year, month: $month, day: $day)
    }
    
    class Coordinator: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
        private let pickerType: PickerType
        @Binding var year: Int
        @Binding var month: Int
        @Binding var day: Int?
        
        init(pickerType: PickerType, year: Binding<Int>, month: Binding<Int>, day: Binding<Int?>) {
            self.pickerType = pickerType
            self._year = year
            self._month = month
            self._day = day
        }
        
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return pickerType.components.count
        }
        
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            guard let dateComponent = Component(rawValue: component) else { return .zero }
            switch dateComponent {
            case .year:
                return Component.years.count
            case .month:
                return Component.months.count
            case .day:
                return Component.daysInMonths(year: year, month: month).count
            }
        }
        
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            guard let dateComponent = Component(rawValue: component) else { return nil }
            switch dateComponent {
            case .year:
                return "\(Component.years[row])년"
            case .month:
                return "\(Component.months[row])월"
            case .day:
                return "\(Component.daysInMonths(year: year, month: month)[row])일"
            }
        }
        
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            guard let dateComponent = Component(rawValue: component) else { return }
            switch dateComponent {
            case .year:
                year = Component.years[row]
            case .month:
                month = Component.months[row]
                print("월", Component.months[row], month)
                pickerView.reloadComponent(Component.day.rawValue)
            case .day:
                day = Component.daysInMonths(year: year, month: month)[row]
            }
        }
    }
}

#Preview {
//    let currentYear = Calendar.current.component(.year, from: .now)
//    let currentMonth = Calendar.current.component(.month, from: .now)
//    let currentDay = Calendar.current.component(.day, from: .now)
//    return CustomDatePicker(.fullDate, year: .constant(currentYear), month: .constant(currentMonth), day: .constant(currentDay))
    CustomDatePickerView()
}
