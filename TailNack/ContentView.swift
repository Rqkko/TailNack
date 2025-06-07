//
//  ContentView.swift
//  TailNack
//
//  Created by Wongsathorn Chengcharoen on 7/6/2568 BE.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var nails: [FingerNail]

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
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
                        }
                        Spacer()
                        Button("Undo") {
                            undo(nail)
                        }
                        .disabled(nail.usageCount == 0)
                    }
                    .padding(.horizontal)
                }
            }
            .navigationTitle("TailNack")
            .onAppear {
                if nails.isEmpty { seedInitialNails() }
            }
        }
    }

    private func increment(_ nail: FingerNail) {
        nail.usageCount += 1
        nail.lastUsed = Date()
    }

    private func undo(_ nail: FingerNail) {
        if nail.usageCount > 0 {
            nail.usageCount -= 1
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
