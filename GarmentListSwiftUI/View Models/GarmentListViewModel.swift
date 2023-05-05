//
//  GarmentListViewModel.swift
//  LuLuLemonProjectSwiftUI
//
//  Created by Talor Levy on 3/24/23.
//

import Foundation


class GarmentListViewModel: ObservableObject {

    @Published var garmentList: [Garment] = []
    
    func refreshGarments() {
        garmentList = CoreDataManager.shared.garmentList
    }
    
    func sortGarmentList(segment: SegControl) {
        CoreDataManager.shared.sortGarmentList(segment: segment)
        refreshGarments()
    }
    
    func deleteGarment(garment: Garment) {
        CoreDataManager.shared.deleteGarment(garment: garment)
    }
}
