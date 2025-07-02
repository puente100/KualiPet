//
//  PetDetailView.swift
//  KualiPet
//
//  Created by Daniel Puente on 6/24/25.
//


import SwiftUI
import CoreData

struct PetDetailView: View {
    @Environment(\.managedObjectContext) private var viewContext
    var pet: Pet

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Pet Details")) {
                    Text("Name: \(pet.name ?? "name")")
                    Text("Species: \(pet.species ?? "Specie")")
                    
                    if let birthdate = pet.birthdate {
                        Text("Birthdate: \(birthdate.formatted(date: .long, time: .omitted))")
                    } else {
                        Text("Birthdate: Not set")
                    }
                    
                    Text(String(format: "Weight: %.1f kg", pet.weight))
                }

                if let imageData = pet.imageData, let uiImage = UIImage(data: imageData) {
                    Section(header: Text("Photo")) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                }

                Section(header: Text("Events")) {
                    NavigationLink("View Events") {
                        EventListView(pet: pet)
                    }
                }
            }
            .navigationTitle(pet.name ?? "Pet")
        }
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    let pet = Pet(context: context)
    pet.name = "Luna"
    pet.species = "Dog"
    pet.birthdate = Date()
    pet.weight = 12.3
    return PetDetailView(pet: pet).environment(\.managedObjectContext, context)
}
