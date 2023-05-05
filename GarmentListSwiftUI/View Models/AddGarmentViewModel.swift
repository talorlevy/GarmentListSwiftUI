//
//  AddGarment.swift
//  LuLuLemonProjectSwiftUI
//
//  Created by Talor Levy on 3/24/23.
//

import Foundation


class AddGarmentViewModel {
    
    func addGarment(name: String) {
        CoreDataManager.shared.addGarment(name: name)
    }
    
    func updateGarment(garment: Garment, updatedName: String) {
        CoreDataManager.shared.updateGarment(garment: garment, updatedName: updatedName)
    }
}
