//
//  Pet+Extensions.swift
//  KualiPet
//
//  Created by Daniel Puente on 6/24/25.
//


import Foundation
import CoreData
import SwiftUI

extension Pet {
    var petName: String {
        name ?? "Unnamed Pet"
    }

    var petSpecies: String {
        species ?? "Unknown"
    }

    var age: Int {
        guard let birthdate = birthdate else { return 0 }
        let calendar = Calendar.current
        return calendar.dateComponents([.year], from: birthdate, to: Date()).year ?? 0
    }

    var petImage: Image {
        if let data = imageData, let uiImage = UIImage(data: data) {
            return Image(uiImage: uiImage)
        } else {
            return Image(systemName: "pawprint.fill")
        }
    }
}
