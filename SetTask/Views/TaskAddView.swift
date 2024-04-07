//
//  SetTask
//
//  Created by Egor Poimanov on 2024-04-06.
//
//  and Igor Tsyupko, Nizar Atassi, Bulat Khungureev
//
//  TaskAddView.swift

import SwiftUI

struct TaskAddView: View {
    @Binding var showingTaskAddView: Bool
    var addTask: (String, Date) -> Void
    
    @State private var taskName: String = ""
    @State private var dueDate = Date()
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Task Details")) {
                    TextField("Task Name", text: $taskName)
                    DatePicker("Due Date", selection: $dueDate, displayedComponents: .date)
                }
            }
            .navigationBarTitle("New Task", displayMode: .inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    self.showingTaskAddView = false
                },
                trailing: Button("Save") {
                    addTask(taskName, dueDate)
                    self.showingTaskAddView = false
                }.disabled(taskName.isEmpty)
            )
        }
    }
}
