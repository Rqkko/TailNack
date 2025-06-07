import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: [SortDescriptor(\FingerNail.sortIndex)]) private var nails: [FingerNail]
    @State private var undoStack: [FingerNail] = []
    @State private var selectedNail: FingerNail?
    @State private var selectedSize: Int = 0
    @State private var showingSizePicker = false

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
                            VStack(alignment: .leading, spacing: 4) {
                                Text(nail.name)
                                    .font(.headline)

                                Text("Used: \(nail.usageCount)")
                                    .font(.subheadline)

                                Text("Last: \(nail.lastUsed?.formatted() ?? "-")")
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                            }

                            Spacer()
                            
                            Button(action: {
                                selectedNail = nail
                                selectedSize = nail.size ?? 0
                                showingSizePicker = true
                            }) {
                                HStack {
                                    Text("Size: \(nail.size.map(String.init) ?? "-")")
                                }
                                .padding(.trailing, 16)
                            }
                            .sheet(isPresented: $showingSizePicker) {
                                VStack {
                                    Text("Select Size")
                                        .font(.headline)

                                    Picker("Size", selection: $selectedSize) {
                                        ForEach(0...10, id: \.self) {
                                            Text("\($0)").tag($0)
                                        }
                                    }
                                    .pickerStyle(.wheel)
                                    .frame(height: 150)

                                    Button("Done") {
                                        if let nail = selectedNail {
                                            nail.size = selectedSize
                                        }
                                        showingSizePicker = false
                                    }
                                    .padding()
                                }
                            }


                            Button(action: {
                                increment(nail)
                            }) {
                                Image(systemName: "plus.circle.fill")
                                    .resizable()
                                    .frame(width: 28, height: 28)
                                    .foregroundColor(.blue)
                            }
                            .padding(.leading, 16)
                            .padding(.trailing, 16)
                        }
                        .padding(.vertical, 6)
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
