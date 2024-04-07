//
//  SetTask
//
//  Created by Egor Poimanov on 2024-04-07.
//
//  and Igor Tsyupko, Nizar Atassi, Bulat Khungureev
//
//  AddGroupView.swift


import SwiftUI

struct AddGroupView: View {
    @Binding var showingAddGroupView: Bool
    var addGroup: (String) -> Void
    
    @State private var groupName: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Group Name", text: $groupName)
                Button("Add Group") {
                    addGroup(groupName)
                    showingAddGroupView = false
                }
                .disabled(groupName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
            .navigationBarTitle("New Group", displayMode: .inline)
            .navigationBarItems(trailing: Button("Cancel") {
                showingAddGroupView = false
            })
        }
    }
}
