//
//  PetListView.swift
//  KualiPet
//
//  Created by Daniel Puente on 6/24/25.
//

import SwiftUI
import CoreData

struct PetListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        entity: Pet.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Pet.name, ascending: true)]
    ) private var pets: FetchedResults<Pet>
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(pets) { pet in
                    NavigationLink(destination: PetDetailView(pet: pet)) {
                        HStack {
                            if let data = pet.imageData, let image = UIImage(data: data) {
                                Image(uiImage: image)
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(Color.gray.opacity(0.4), lineWidth: 1))
                            }
                            
                            VStack(alignment: .leading) {
                                Text(pet.name ?? "Unnamed")
                                    .font(.headline)
                                
                                if let species = pet.species {
                                    Text(species)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .navigationTitle("My Pets")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: addSamplePet) {
                        Label("Add Pet", systemImage: "plus")
                    }
                }
            }
        }
    }
    
    private func addSamplePet() {
        withAnimation {
            let newPet = Pet(context: viewContext)
            newPet.name = "Luna"
            newPet.species = "Cat"
            newPet.birthdate = Calendar.current.date(byAdding: .year, value: -3, to: Date())
            newPet.weight = 4.3
            try? viewContext.save()
        }
    }
}

#Preview {
    PetListView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
