//
//  SetTask
//
//  Created by Egor Poimanov on 2024-04-06.
//
//  and Igor Tsyupko, Nizar Atassi, Bulat Khungureev
//
//  ContentView.swift


import SwiftUI

struct Task: Identifiable, Hashable {
    var id = UUID()
    var name: String
    var dueDate: Date
    var originalGroupID: UUID
}

struct TaskGroup: Identifiable, Hashable {
    var id = UUID()
    var name: String
    var tasks: [Task]
}

class TaskGroupsModel: ObservableObject {
    @Published var taskGroups: [TaskGroup] = [
        TaskGroup(name: "Everyday", tasks: [
            Task(name: "Go to gym", dueDate: Date(), originalGroupID: UUID())
        ]),
        TaskGroup(name: "Late", tasks: [])
    ]

    init() {
        updateLateTasks()
    }

    func updateLateTasks() {
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        let lateTasks = taskGroups.flatMap { $0.tasks }.filter { $0.dueDate < yesterday }
        if let index = taskGroups.firstIndex(where: { $0.name == "Late" }) {
            taskGroups[index].tasks = lateTasks
        } else {
            let lateGroup = TaskGroup(name: "Late", tasks: lateTasks)
            taskGroups.append(lateGroup)
        }
    }

    func addGroup(_ groupName: String) {
        if let index = taskGroups.firstIndex(where: { $0.name == "Late" }) {
            taskGroups.insert(TaskGroup(name: groupName, tasks: []), at: index)
        } else {
            taskGroups.append(TaskGroup(name: groupName, tasks: []))
        }
    }
}

struct ContentView: View {
    @ObservedObject var model = TaskGroupsModel()
    @State private var selectedGroup: TaskGroup?
    @State private var showingTaskAddView = false
    @State private var showingAddGroupView = false
    @State private var isEditing = false

    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter
    }
    
    private func groupContainsLateTasks(_ group: TaskGroup) -> Bool {
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        return group.tasks.contains(where: { $0.dueDate < yesterday })
    }
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(selectedGroup?.tasks ?? [], id: \.self) { task in
                        TaskRow(task: task, dateFormatter: dateFormatter)
                    }
                    .onDelete(perform: deleteTask)
                }
                .padding(.top, 10)

                Spacer()

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(model.taskGroups.indices, id: \.self) { index in
                            HStack {
                                if self.isEditing && self.model.taskGroups[index].name != "Everyday" && self.model.taskGroups[index].name != "Late" {
                                    Button(action: {
                                        self.model.taskGroups.remove(at: index)
                                    }) {
                                        Image(systemName: "minus.circle.fill")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 24, height: 24)
                                            .foregroundColor(.red)
                                            .padding(.leading, 10)
                                            .padding(.trailing, 5)
                                    }
                                }
                                Button(action: {
                                    self.selectedGroup = model.taskGroups[index]
                                }) {
                                    Text(model.taskGroups[index].name)
                                        .frame(width: 100, height: 40)
                                        .foregroundColor(model.taskGroups[index].name == "Late" && groupContainsLateTasks(model.taskGroups[index]) ? .red : .primary)
                                }
                                if model.taskGroups[index].name == "Late" {
                                    Button(action: {
                                        self.showingAddGroupView = true
                                    }) {
                                        Image(systemName: "plus.circle.fill")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 24, height: 24)
                                            .foregroundColor(.blue)
                                            .padding(.leading, 10)
                                            .padding(.trailing, 5)
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 10)
                }
                .padding(.bottom, 10)
            }
            
            .navigationBarItems(leading: Button(action: {
                self.isEditing.toggle()
            }) {
                Text(isEditing ? "Done" : "Edit")
            }, trailing: Button(action: {
                self.showingTaskAddView.toggle()
            }) {
                Text("New Task!")
            })
            .navigationBarTitle(selectedGroup?.name ?? "Tasks", displayMode: .inline)
            .onAppear {
                self.selectedGroup = self.model.taskGroups.first(where: { $0.name == "Everyday" })
            }
            .sheet(isPresented: $showingTaskAddView) {
                TaskAddView(showingTaskAddView: $showingTaskAddView) { taskName, dueDate in
                    guard let index = self.model.taskGroups.firstIndex(where: { $0.id == self.selectedGroup?.id }) else { return }
                    let newTask = Task(name: taskName, dueDate: dueDate, originalGroupID: self.selectedGroup!.id)
                    self.model.taskGroups[index].tasks.append(newTask)
                    self.selectedGroup?.tasks.append(newTask)
                    self.model.updateLateTasks()
                }
            }
            .sheet(isPresented: $showingAddGroupView) {
                AddGroupView(showingAddGroupView: $showingAddGroupView, addGroup: model.addGroup)
            }
        }
    }
    
    private func deleteTask(at offsets: IndexSet) {
        guard let selectedGroup = selectedGroup,
              let selectedGroupIndex = model.taskGroups.firstIndex(where: { $0.id == selectedGroup.id }) else { return }
        
        model.taskGroups[selectedGroupIndex].tasks.remove(atOffsets: offsets)

        if selectedGroup.name == "Late" {
            offsets.forEach { offset in
                let task = selectedGroup.tasks[offset]
                if let originalGroupIndex = model.taskGroups.firstIndex(where: { $0.id == task.originalGroupID }),
                   let originalTaskIndex = model.taskGroups[originalGroupIndex].tasks.firstIndex(where: { $0.id == task.id }) {
                    model.taskGroups[originalGroupIndex].tasks.remove(at: originalTaskIndex)
                }
            }
        }

        self.selectedGroup?.tasks = model.taskGroups[selectedGroupIndex].tasks

        model.updateLateTasks()
    }

    private struct TaskRow: View {
        let task: Task
        let dateFormatter: DateFormatter

        var body: some View {
            HStack {
                Text(task.name)
                Spacer()
                Text(dateFormatter.string(from: task.dueDate))
                    .foregroundColor(.gray)
                    .font(.caption)
            }
        }
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
