//
//  PetViewModel.swift
//  KualiPet
//
//  Created by Daniel Puente on 6/23/25.
//

import Foundation
import CoreData

class PetViewModel: ObservableObject {
    private let viewContext: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.viewContext = context
    }

    func addPet(name: String, species: String, birthdate: Date, weight: Double, imageData: Data? = nil) {
        let newPet = Pet(context: viewContext)
        newPet.name = name
        newPet.species = species
        newPet.birthdate = birthdate
        newPet.weight = weight
        newPet.imageData = imageData

        saveContext()
    }

    func deletePet(_ pet: Pet) {
        viewContext.delete(pet)
        saveContext()
    }

    func saveContext() {
        do {
            try viewContext.save()
        } catch {
            print("Error saving context: \(error.localizedDescription)")
        }
    }
}
