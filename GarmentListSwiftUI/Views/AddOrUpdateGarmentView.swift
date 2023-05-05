//
//  AddGarmentView.swift
//  LuLuLemonProjectSwiftUI
//
//  Created by Talor Levy on 3/24/23.
//

import SwiftUI
import CoreData


struct AddOrUpdateGarmentView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State private var isDisabled: Bool = true
    @State var name: String = ""
    @State var textFieldVerb: String = ""
    
    var addGarmentViewModel = AddGarmentViewModel()
    var garment: Garment?
    
    
    var body: some View {
        VStack {
           Text(textFieldVerb + " Garment")
                .bold()
                .font(.largeTitle)
            TextField("Garment name", text: $name)
                .foregroundColor(.black)
                .padding([.leading, .trailing], 25)
                .padding(.top, 10)
                .textFieldStyle(.roundedBorder)
            Spacer()
        }
        .onChange(of: name) { _ in
            if !name.isEmpty {
                isDisabled = false
            } else {
                isDisabled = true
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    if garment == nil {
                        addGarmentViewModel.addGarment(name: name)
                        dismiss()
                    } else {
                        if !name.isEmpty {
                            garment?.name = name
                            if let garment = garment {
                                addGarmentViewModel.updateGarment(garment: garment, updatedName: name)
                                dismiss()
                            }
                        }
                    }
                }
                .disabled(isDisabled)
            }
        }
    }
}

struct AddGarmentView_Previews: PreviewProvider {
    static var previews: some View {
        AddOrUpdateGarmentView(name: "", garment: nil)
    }
}

