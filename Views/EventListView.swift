//
//  EventListView.swift
//  KualiPet
//
//  Created by Daniel Puente on 6/24/25.

import SwiftUI
import CoreData

struct EventListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    var pet: Pet

    @FetchRequest private var events: FetchedResults<Event>
    @State private var showingAddEvent = false

    init(pet: Pet) {
        self.pet = pet
        _events = FetchRequest<Event>(
            sortDescriptors: [NSSortDescriptor(keyPath: \Event.date, ascending: false)],
            predicate: NSPredicate(format: "pet == %@", pet),
            animation: .default
        )
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(events) { event in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(event.title ?? "")
                            .font(.headline)
                        
                        if let date = event.date {
                            Text(date, style: .date)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        } else {
                            Text("No date")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        
                        if !(event.notes ?? "").isEmpty {
                            Text(event.notes ?? "")
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.vertical, 6)
                }
                .onDelete(perform: deleteEvents)
            }
            .navigationTitle("Events for \(pet.name ?? "Unknown")")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddEvent = true }) {
                        Label("Add Event", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddEvent) {
                AddEventView(pet: pet)
            }
        }
    }
    private func deleteEvents(at offsets: IndexSet) {
        for index in offsets {
            let eventToDelete = events[index]
            viewContext.delete(eventToDelete)
        }

        do {
            try viewContext.save()
        } catch {
            print("Error deleting event: \(error.localizedDescription)")
        }
    }

}
