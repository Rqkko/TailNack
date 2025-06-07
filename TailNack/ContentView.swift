import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var nails: [FingerNail]
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
                            undoLast()
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
        nail.usageCount += 1
        nail.lastUsed = Date()
        undoStack.append(nail)
    }

    private func undo(_ nail: FingerNail) {
        guard nail.usageCount > 0 else { return }
        nail.usageCount -= 1

        // Remove the *most recent* occurrence of this nail from the undo stack
        if let lastIndex = undoStack.lastIndex(where: { $0.id == nail.id }) {
            undoStack.remove(at: lastIndex)
        }
    }

    private func undoLast() {
        guard let last = undoStack.popLast() else { return }
        if last.usageCount > 0 {
            last.usageCount -= 1
        }
    }

    private func seedInitialNails() {
        let names = [
            "Left Thumb", "Left Index", "Left Middle", "Left Ring", "Left Pinky",
            "Right Thumb", "Right Index", "Right Middle", "Right Ring", "Right Pinky"
        ]
        for name in names {
            let nail = FingerNail(name: name)
            modelContext.insert(nail)
        }
    }
}
