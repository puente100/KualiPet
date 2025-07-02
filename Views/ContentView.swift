//
//  ContentView.swift
//  KualiPet
//
//  Created by Daniel Puente on 6/23/25.
//
import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Pet.name, ascending: true)],
        animation: .default
    ) private var pets: FetchedResults<Pet>
    
    @State private var showingAddPet = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(pets) { pet in
                    NavigationLink(destination: PetDetailView(pet: pet)) {
                        HStack {
                            if let data = pet.imageData, let image = UIImage(data: data) {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 50, height: 50)
                                    .clipShape(Circle())
                            }
                            
                            VStack(alignment: .leading) {
                                Text(pet.name ?? "Unnamed")
                                    .font(.headline)
                                Text(pet.species ?? "Unknown")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
                .onDelete(perform: deletePets)
            }
            .navigationTitle("My Pets")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddPet = true }) {
                        Label("Add Pet", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddPet) {
                AddPetView(context: viewContext)
            }
        }
    }
    
    private func deletePets(at offsets: IndexSet) {
        for index in offsets {
            let petToDelete = pets[index]
            viewContext.delete(petToDelete)
        }

        do {
            try viewContext.save()
        } catch {
            print("Error deleting pet: \(error.localizedDescription)")
        }
    }

}


#Preview {
    let context = PersistenceController.preview.container.viewContext
    return ContentView()
        .environment(\.managedObjectContext, context)
}
