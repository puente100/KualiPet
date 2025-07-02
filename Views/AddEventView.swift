//
//  AddEventView.swift
//  KualiPet
//
//  Created by Daniel Puente on 6/24/25.
//

import SwiftUI

struct AddEventView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) private var viewContext

    var pet: Pet

    @State private var title = ""
    @State private var date = Date()
    @State private var notes = ""

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Event Info")) {
                    TextField("Title", text: $title)
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                    TextField("Notes", text: $notes, axis: .vertical)
                        .lineLimit(3...5)
                }
            }
            .navigationTitle("New Event")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { saveEvent() }
                        .disabled(title.isEmpty)
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }

    private func saveEvent() {
        let newEvent = Event(context: viewContext)
        newEvent.title = title
        newEvent.date = date
        newEvent.notes = notes
        newEvent.pet = pet
        newEvent.isArchived = false

        do {
            try viewContext.save()
            dismiss()
        } catch {
            print("Error saving event: \(error.localizedDescription)")
        }
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    let pet = Pet(context: context)
    pet.name = "Luna"
    return AddEventView(pet: pet).environment(\.managedObjectContext, context)
}
