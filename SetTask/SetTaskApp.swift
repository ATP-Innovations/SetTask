//
//  SetTask
//
//  Created by Egor Poimanov on 2024-04-06.
//
//  and Igor Tsyupko, Nizar Atassi, Bulat Khungureev
//
//  SetTaskApp.swift



import SwiftUI
import CoreData

@main
struct SetTaskApp: App {
    @State private var showLaunchScreen = true
    
    // MARK: - Core Data stack
    
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TaskModel")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    var body: some Scene {
        WindowGroup {
            if showLaunchScreen {
                LaunchScreen()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                            withAnimation {
                                showLaunchScreen = false
                            }
                        }
                    }
            } else {
                ContentView().environment(\.managedObjectContext, persistentContainer.viewContext)
            }
        }
    }
}
