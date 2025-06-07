import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: [SortDescriptor(\FingerNail.sortIndex)]) private var nails: [FingerNail]
    @State private var undoStack: [FingerNail] = []


    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Fixed header with title and Undo button
                    HStack {
                        Text("TailNack")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        Spacer()
                        Button("Undo") {
                            undo()
                        }
                        .disabled(undoStack.isEmpty)
                    }
                    .padding(.horizontal)
                    .padding(.top)

                    Divider()

                    // Nail buttons
                    ForEach(nails) { nail in
                        HStack {
                            Button(action: {
                                increment(nail)
                            }) {
                                VStack(alignment: .leading) {
                                    Text(nail.name)
                                        .font(.headline)
                                    Text("Used: \(nail.usageCount)")
                                        .font(.subheadline)
                                    if let lastUsed = nail.lastUsed {
                                        Text("Last used: \(lastUsed.formatted(date: .abbreviated, time: .shortened))")
                                            .font(.caption)
                                    }
                                }
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.bottom)
            }
        }
        .onAppear {
            if nails.isEmpty { seedInitialNails() }
        }
    }

    private func increment(_ nail: FingerNail) {
        nail.usageTimestamps.append(Date())
        undoStack.append(nail)
    }

    private func undo() {
        guard let last = undoStack.popLast() else { return }
        guard !last.usageTimestamps.isEmpty else { return }
        last.usageTimestamps.removeLast()
    }

    private func seedInitialNails() {
        let names = [
            "Left Thumb",
            "Left Index",
            "Left Middle",
            "Left Ring",
            "Left Pinky",
            "Right Thumb",
            "Right Index",
            "Right Middle",
            "Right Ring",
            "Right Pinky"
        ]

        for (index, name) in names.enumerated() {
            let nail = FingerNail(name: name, sortIndex: index)
            modelContext.insert(nail)
        }
    }
}
