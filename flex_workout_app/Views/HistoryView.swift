//
//  HistoryView.swift
//  flex_workout_app
//
//  Created by Alex Chen on 11/12/24.
//

import SwiftUI
import Charts

struct HistoryView: View {
    @StateObject var viewModel = HistoryViewModel()
    
    @State private var selectedExerciseId: Int?
        
    var exerciseOptions: [(id: Int, name: String)] {
        let groupedExercises = Dictionary(grouping: viewModel.loggedSets) { $0.user_exercise_id }
        return groupedExercises.compactMap { id, sets in
            if let name = sets.first?.user_exercise_name {
                return (id: id, name: name)
            }
            return nil
        }.sorted { $0.name < $1.name }
    }
    
    var selectedSets: [LoggedExerciseSet]? {
        guard let selectedId = selectedExerciseId else { return nil }
        return viewModel.loggedSets.filter { $0.user_exercise_id == selectedId }
    }
    
    var body: some View {
            VStack(spacing: 20) {
                Text("Flex")
                    .font(.title)
                    .fontWeight(.bold)
                    .italic()
                    .foregroundColor(.cyan)
                // Exercise Picker
                
                HStack {
                    Picker("Select Exercise", selection: $selectedExerciseId) {
                        Text("Select Exercise")
                            .tag(Optional<Int>.none)
                        ForEach(exerciseOptions, id: \.id) { exercise in
                            Text(exercise.name)
                                .tag(Optional(exercise.id))
                        }
                    }
                    .pickerStyle(.menu)
                    .frame(maxWidth: 300, alignment: .leading) // Align Picker to the leading edge

                    Spacer() // Pushes the Picker to the leading side
                }
                .padding(.bottom, 100)
                
                
                VStack {
                    if let sets = selectedSets, !sets.isEmpty {
                        ExerciseChart(sets: sets)
                            .frame(height: 300)
                            .padding(.top)
                    } else {
                        ContentUnavailableView(
                            "Select an Exercise",
                            systemImage: "figure.walk",
                            description: Text("Choose an exercise from the menu above to view its progress")
                        )
                    }
                }
                
                
                Spacer()
            }
            .padding()
            .onAppear {
                // Automatically select the first exercise if none is selected
                if selectedExerciseId == nil && !exerciseOptions.isEmpty {
                    selectedExerciseId = exerciseOptions[0].id
                }
            }
            .task {
                await getHistory()
            }
        }
    func getHistory() async {
        do {
            try await viewModel.getHistory()
        } catch {
            // Handle specific errors here
            print("Error fetching history: \(error)")
        }
    }
}

struct ExerciseChart: View {
    let sets: [LoggedExerciseSet]
    @State private var selectedSet: LoggedExerciseSet?
    
    private var dateRange: ClosedRange<Date> {
        let sortedDates = sets.map { $0.createdAt }.sorted()
        return sortedDates.first!...sortedDates.last!
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Chart Section
            Chart(sets.sorted(by: { $0.createdAt < $1.createdAt })) { set in
                LineMark(
                    x: .value("Date", set.createdAt),
                    y: .value("Weight", set.weight)
                )
                .interpolationMethod(.catmullRom)
                .foregroundStyle(Color.cyan)
                
                PointMark(
                    x: .value("Date", set.createdAt),
                    y: .value("Weight", set.weight)
                )
                .foregroundStyle(set == selectedSet ? Color.cyan : Color.cyan.opacity(0.5))
                .symbol {
                    Circle()
                        .fill(set == selectedSet ? Color.cyan : Color.white)
                        .overlay(
                            Circle().stroke(Color.cyan)
                        )
                        .frame(width: 10, height: 10)
                }

            }
            .frame(height: 300)
            .chartXAxis {
                AxisMarks(values: .stride(by: .month)) { value in
                    AxisGridLine(stroke: StrokeStyle(dash: [5, 5]))
                        .foregroundStyle(.gray.opacity(0.3))
                    AxisValueLabel(format: .dateTime.month(.abbreviated))
                        .foregroundStyle(.gray)
                        .font(.system(size: 14))
                }
            }
            .chartYAxis {
                AxisMarks(position: .leading) { value in
                    AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5))
                        .foregroundStyle(.gray.opacity(0.3))
                    AxisValueLabel {
                        Text("\(value.as(Double.self)?.formatted() ?? "")")
                            .font(.system(size: 14))
                            .foregroundStyle(.gray)
                    }
                }
            }
            .chartOverlay { proxy in
                GeometryReader { geometry in
                    Rectangle()
                        .fill(.clear)
                        .contentShape(Rectangle())
                        .gesture(
                            SpatialTapGesture()
                                .onEnded { value in
                                    let x = value.location.x - geometry[proxy.plotAreaFrame].origin.x
                                    guard let date = proxy.value(atX: x, as: Date.self) else { return }
                                    if let tappedSet = findClosestSet(to: date) {
                                        // Toggle selection
                                        //selectedSet = tappedSet
                                        if selectedSet == tappedSet {
                                            selectedSet = nil
                                        } else {
                                            selectedSet = tappedSet
                                        }
                                    }
                                }
                        )
                }
            }
            
            // Details Panel
            if let set = selectedSet {
                VStack(alignment: .leading, spacing: 8) {
                    Text(set.createdAt.formatted(date: .long, time: .omitted))
                        .font(.headline)
                        .foregroundColor(.gray)
                    
                    HStack(spacing: 24) {
                        DetailItem(label: "Weight", value: "\(String(format: "%.1f", set.weight)) lbs")
                        DetailItem(label: "Set Number", value: "\(set.setNumber)")
                        DetailItem(label: "Reps", value: "\(set.repsCompleted)")
                    }
                }
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.systemBackground))
                        .shadow(radius: 2)
                }
                //.transition(.opacity.combined(with: .move(edge: .bottom)))
            } else {
                Spacer().frame(height: 100) // Reserve space for details panel
            }
        }
    }
    
    private func findClosestSet(to date: Date) -> LoggedExerciseSet? {
        let sortedSets = sets.sorted { abs($0.createdAt.timeIntervalSince(date)) < abs($1.createdAt.timeIntervalSince(date)) }
        return sortedSets.first
    }
}

// Helper view for detail items
struct DetailItem: View {
    let label: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.caption)
                .foregroundColor(.gray)
            Text(value)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.cyan)
        }
    }
}

//struct ExerciseChart: View {
//    let sets: [LoggedExerciseSet]
//    
//    private var dateRange: ClosedRange<Date> {
//        let sortedDates = sets.map { $0.createdAt }.sorted()
//        return sortedDates.first!...sortedDates.last!
//    }
//    
//    var body: some View {
//        VStack(alignment: .leading, spacing: 8) {
//            Chart(sets.sorted(by: { $0.createdAt < $1.createdAt })) { set in
//                LineMark(
//                    x: .value("Date", set.createdAt),
//                    y: .value("Weight", set.weight)
//                )
//                .interpolationMethod(.catmullRom)
//                .foregroundStyle(.blue)
//            }
//            .chartXAxis {
//                AxisMarks(values: .stride(by: .month)) { value in
//                    AxisGridLine(stroke: StrokeStyle(dash: [5, 5]))
//                        .foregroundStyle(.gray.opacity(0.3))
//                    AxisValueLabel(format: .dateTime.month(.abbreviated))
//                        .foregroundStyle(.gray)
//                }
//            }
//            .chartYAxis {
//                AxisMarks(position: .leading) { _ in
//                    AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5))
//                        .foregroundStyle(.gray.opacity(0.3))
//                    AxisTick(stroke: StrokeStyle(lineWidth: 0))
//                    AxisValueLabel()
//                        .foregroundStyle(.gray)
//                }
//            }
//            .chartPlotStyle { plotArea in
//                plotArea
//                    .background(.white)
//            }
//            
//            // Legend
//            Text(sets.first?.user_exercise_name ?? "Exercise")
//                .font(.caption)
//                .foregroundStyle(.gray)
//        }
//    }
//}

#Preview {
    HistoryView()
}
