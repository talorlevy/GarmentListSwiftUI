//
//  GarmentListView.swift
//  LuLuLemonProjectSwiftUI
//
//  Created by Talor Levy on 3/24/23.
//

import SwiftUI


struct GarmentListView: View {

    @State private var segment: SegControl = .alphabetic

    @ObservedObject var garmentListViewModel = GarmentListViewModel()
    
    var segmentNames: [SegControl] = [.alphabetic, .creationTime]
    
    
    init(){
        CoreDataManager.shared.fetchGarmentsFromCoreData()
        UISegmentedControl.appearance().selectedSegmentTintColor = .cyan
    }
    
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("Sort order", selection: $segment) {
                    ForEach(segmentNames, id: \.self) {
                        Text($0.rawValue)
                    }
                }
                .pickerStyle(.segmented)
                .padding([.trailing, .leading], 35)
                List {
                    let garmentList = garmentListViewModel.garmentList
                    ForEach(garmentList, id: \.self) { garment in
                        if let name = garment.name {
                            NavigationLink(destination: AddOrUpdateGarmentView(name: name, textFieldVerb: "Update", garment: garment)) {
                                Text(name)
                            }
                        }
                    }.onDelete(perform: { indexSet in
                        indexSet.forEach { index in
                            let garment = garmentList[index]
                            garmentListViewModel.deleteGarment(garment: garment)
                            garmentListViewModel.sortGarmentList(segment: segment)
                        }
                    })
                }
            }
            .padding()
            .navigationTitle("List")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: AddOrUpdateGarmentView(name: "", textFieldVerb: "Add", garment: nil)) {
                        Image(systemName: "plus.circle")
                    }
                }
            }
            .onAppear {
                garmentListViewModel.refreshGarments()
                garmentListViewModel.sortGarmentList(segment: segment)
            }
            .onChange(of: segment) { segment in
                garmentListViewModel.sortGarmentList(segment: segment)
            }
        }
    }
}


//struct GarmentListView_Previews: PreviewProvider {
//    static var previews: some View {
//        GarmentListView()
//    }
//}
