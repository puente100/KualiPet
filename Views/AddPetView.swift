//
//  AddPetView.swift
//  KualiPet
//
//  Created by Daniel Puente on 6/24/25.
//
import CoreData
import SwiftUI

struct AddPetView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var viewModel: PetViewModel

    @State private var name = ""
    @State private var species = "Dog"
    @State private var birthdate = Date()
    @State private var weight = ""
    @State private var image: UIImage?
    @State private var showImagePicker = false

    init(context: NSManagedObjectContext) {
        _viewModel = StateObject(wrappedValue: PetViewModel(context: context))
    }

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Pet Info")) {
                    TextField("Name", text: $name)
                    TextField("Species", text: $species)
                    DatePicker("Birthdate", selection: $birthdate, displayedComponents: .date)
                    TextField("Weight (kg)", text: $weight)
                        .keyboardType(.decimalPad)
                }

                Section(header: Text("Photo")) {
                    if let image = image {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 150)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    Button("Select Photo") {
                        showImagePicker = true
                    }
                }
            }
            .navigationTitle("Add Pet")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { savePet() }
                        .disabled(name.isEmpty || weight.isEmpty)
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(image: $image)
            }
        }
    }

    private func savePet() {
        let weightValue = Double(weight) ?? 0
        let imageData = image?.jpegData(compressionQuality: 0.8)
        viewModel.addPet(name: name, species: species, birthdate: birthdate, weight: weightValue, imageData: imageData)
        dismiss()
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    return AddPetView(context: context)
}
