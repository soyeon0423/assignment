//
//  CpmViewModel.swift
//  CpmAnalysis
//
//  Created by 김형관 on 2022/04/24.
//

import Foundation
import CoreData

class CpmViewModel: ObservableObject {
    
    let container : NSPersistentContainer
    
    @Published var savedActivities: [Activity] = []
    
    var project = Project()
    
    init() {
        container = NSPersistentContainer(name: "Activity")
        container.loadPersistentStores { (description, error) in
            if let error = error {
                print("Error loading \(error)")
            }
        }
        fetchActivities()
    }
    
    
    func fetchActivities() {
        let request = NSFetchRequest<Activity>(entityName: "Activity")
        
        do {
            savedActivities = try container.viewContext.fetch(request)
            project.schedules.removeAll()
            var initialSchedule = [ActivitySoft]()
            for activity in savedActivities {
                initialSchedule.append(ActivitySoft(id: activity.id, description: activity.name ?? "", duration: activity.duration, predecessors: activity.predecessors ?? [], sucessors: activity.successors ?? []))
            }
            project.schedules.append(Schedule(schedule: initialSchedule))
            
        } catch let error {
            print("Error handling \(error)")
        }
    }
    
    func addActivity(id: Int32,
                     name: String,
                     duration: Int32,
                     predecessors: [Int32],
                     successors: [Int32]) {
        let newActivity = Activity(context: container.viewContext)
        newActivity.id = id
        newActivity.name = name
        newActivity.duration = duration
        newActivity.predecessors = predecessors
        newActivity.successors = successors
        saveData()
    }
    
    func deleteActivity(indexSet: IndexSet) {
        guard let index =  indexSet.first else {return}
        let entity = savedActivities[index]
        container.viewContext.delete(entity)
        saveData()
    }
    
    func saveData() {
        do {
            try container.viewContext.save()
            fetchActivities()
        } catch let error {
            print("Error saving \(error)")
        }
    }
    
}
