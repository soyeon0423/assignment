//
//  ActivitySoft.swift
//  CpmAnalysis
//
//  Created by 김형관 on 2022/04/25.
//

import Foundation

class ActivitySoft {
    
    public var id: Int32
    public var description: String
    public var duration: Int32
    public var predecessors: [Int32]
    public var sucessors: [Int32]
    
    public var earlyStart: Int32 = 0
    public var earlyFinish: Int32 = 0
    public var lateStart: Int32 = 0
    public var lateFinish: Int32 = 0
    public var totalFloat: Int32 = 0
    public var freeFloat: Int32 = 0
    
    public var actualStart: Int32 = 0
    public var actualFinish: Int32 = 0
//    public var remainingDuration: Int32 = 0
    
    
    init (id: Int32, description: String, duration: Int32, predecessors: [Int32], sucessors: [Int32]) {
        self.id = id
        self.description = description
        self.duration = duration
        self.predecessors = predecessors
        self.sucessors = sucessors
    }

    init (id: Int32, description: String, duration: Int32, predecessors: [Int32], sucessors: [Int32], actualStart: Int32, actualFinish: Int32) {
        self.id = id
        self.description = description
        self.duration = duration
        self.predecessors = predecessors
        self.sucessors = sucessors
        self.actualStart = actualStart
        self.actualFinish = actualFinish
    }
    
    public func setEarlyTime(earlyStart: Int32, earlyFinish: Int32) {
        self.earlyStart = earlyStart
        self.earlyFinish = earlyFinish
    }
    
    public func setLateTime(lateStart: Int32, lateFinish: Int32) {
        self.lateStart = lateStart
        self.lateFinish = lateFinish
    }
    
    public func isFirst (activities: [ActivitySoft]) -> Bool {
        if predecessors.isEmpty {
            return true
        } else {
            var predArray : [Int32] = []
            for predecessor in predecessors {
                if let comparisonActivity = activities.first(where: {$0.id == predecessor}) {
                    predArray.append(comparisonActivity.actualFinish)
                }
            }
            if predArray.allSatisfy({$0 > 0}) {
                return true
            } else {
                return false
            }
        }
    }
}

class Schedule {
    var startDate: Int32 = 1
    var schedule = [ActivitySoft]()
    
    init() {
        
    }
    
    init (schedule: [ActivitySoft]) {
        self.schedule = schedule
    }
    
    init(startDate: Int32, schedule: [ActivitySoft] ) {
        self.startDate = startDate
        self.schedule = schedule
    }
}
 
class Project {
    
    var result = String()
    var criticalPaths = [[ActivitySoft]]()
    var criticalPath = [ActivitySoft]()

    var schedules: [Schedule] = []
    private func forwardPass(activities: [ActivitySoft], startDay: Int32) -> Int32 {
        var comparisonEarlyFinish: Int32 = 0
        for activity in activities {
            if activity.actualFinish > 0 {
                continue
            }
            
            if activity.isFirst(activities: activities) {
                activity.setEarlyTime(earlyStart: startDay, earlyFinish: startDay + activity.duration)
                comparisonEarlyFinish = startDay + activity.duration
            } else {
                var comparison: Int32 = 0
                for predecessor in activity.predecessors {
                    if let comparisonActivity = activities.first(where: {$0.id == predecessor}) {
                        if comparison < comparisonActivity.earlyFinish {
                            comparison = comparisonActivity.earlyFinish
                        }
                    }
                }
                
                activity.setEarlyTime(earlyStart: comparison, earlyFinish: comparison + activity.duration)
                
                if comparisonEarlyFinish < comparison + activity.duration {
                    comparisonEarlyFinish = comparison + activity.duration
                }
            }
        }
        return comparisonEarlyFinish
    }
    
    private func backwardPass(activities: [ActivitySoft], finishDay: Int32) {
        for activity in activities.reversed() {
            if activity.actualFinish > 0 {
                continue
            }
            
            if activity.sucessors.isEmpty {
                activity.setLateTime(lateStart: finishDay - activity.duration, lateFinish: finishDay)
            } else {
                var comparison: Int32 = 100000
                for sucessor in activity.sucessors {
                    if let comparisonActivity = activities.first(where: {$0.id == sucessor}) {
                        if comparison > comparisonActivity.lateStart {
                            comparison = comparisonActivity.lateStart
                        }
                    }
                }
                activity.setLateTime(lateStart: comparison - activity.duration, lateFinish: comparison)
            }
        }
    }
    
    private func floatCalculation(activities: [ActivitySoft]) -> [ActivitySoft] {
        var criticalActivities : [ActivitySoft] = []
        for activity in activities {
            let startTotalFloat = activity.lateStart - activity.earlyStart
            let finishTotalFloat = activity.lateFinish - activity.earlyFinish
            activity.totalFloat = min(startTotalFloat, finishTotalFloat)
            if activity.totalFloat == 0 {
                activity.freeFloat = 0
            } else {
                var comparison: Int32 = 100000
                if activity.sucessors.isEmpty {
                    comparison = activity.lateFinish
                }
                for sucessor in activity.sucessors {
                    if let comparisonActivity = activities.first(where: {$0.id == sucessor}) {
                        if comparison > comparisonActivity.earlyStart {
                            comparison = comparisonActivity.earlyStart
                        }
                    }
                }
                activity.freeFloat = comparison - activity.earlyFinish
            }
        }
        criticalActivities = activities.filter { $0.totalFloat  == 0 }
        let temp = criticalActivities.filter { $0.actualFinish == 0 }
        return (temp)
    }
    
    private func searchCP(activities: [ActivitySoft], activity: ActivitySoft, criticalActivities: [ActivitySoft]) {

        if activity.isFirst(activities: activities) {
            criticalPath.removeAll()
            criticalPath.append(activity)
        }
        
        if activity.sucessors.isEmpty {
            return
        }
        
        for successor in activity.sucessors {
            
            if let aSuccessor = criticalActivities.first(where: {$0.id == successor}) {
                if aSuccessor.totalFloat == 0 {
                    criticalPath.append(aSuccessor)
                    if aSuccessor.sucessors.isEmpty{
                        criticalPaths.append(criticalPath)
                    }
                }
                searchCP(activities: activities, activity: aSuccessor, criticalActivities: criticalActivities)
                criticalPath.removeLast()
            }
        }
    }

    private func criticalPathFind(activities: [ActivitySoft], criticalActivities: [ActivitySoft]) -> Void {
        criticalPath.removeAll()
        criticalPaths.removeAll()
        for activity in criticalActivities {
            if activity.isFirst(activities: activities) {
                searchCP(activities: activities, activity: activity, criticalActivities: criticalActivities)
            }
        }
    }
    
    private func printProject(activities: [ActivitySoft], criticalActivities: [ActivitySoft]) {
        result.removeAll()

        for activity in activities {

            if activity.actualFinish != 0 {
                result.append("ID = \(activity.id): \(activity.description)\n" )
                result.append("Actual Start: \(activity.actualStart)\n")
                result.append("Actual Finish: \(activity.actualFinish)\n")
            } else if activity.actualStart != 0 {
                result.append("ID = \(activity.id): \(activity.description)\n" )
                result.append("Actual Start: \(activity.actualStart)\n")
                result.append("Early Finish: \(activity.earlyFinish)\n")
                result.append("Late Finish: \(activity.lateFinish)\n")
                result.append("Total Float: \(activity.totalFloat)\n")
                result.append("Free Float: \(activity.freeFloat)\n")
            } else {
                result.append("ID = \(activity.id): \(activity.description)\n" )
                result.append("Early Start: \(activity.earlyStart)\n")
                result.append("Early Finish: \(activity.earlyFinish)\n")
                result.append("Late Start: \(activity.lateStart)\n")
                result.append("Late Finish: \(activity.lateFinish)\n")
                result.append("Total Float: \(activity.totalFloat)\n")
                result.append("Free Float: \(activity.freeFloat)\n")
            }

            result.append("\n")
        }
        
        criticalPathFind(activities: activities, criticalActivities: criticalActivities)
        
        if criticalPaths.isEmpty {
            result.append("There is no critical path.\n")
        } else {
            result.append("Critical Paths \n")
            for criticalPath in criticalPaths {
                for activity in criticalPath {
                    result.append("\(activity.id) ")
                }
                 result.append("\n")
            }
        }
        
        result.append("\n")
    }
    
    public func scheduleCalculation (startDate: Int32) {
        for schedule in schedules {
            let finishDay = forwardPass(activities: schedule.schedule , startDay: startDate)
            backwardPass(activities: schedule.schedule, finishDay: finishDay)
            let criticalActivities = floatCalculation(activities: schedule.schedule)
            printProject(activities: schedule.schedule, criticalActivities: criticalActivities)
        }
    }
}
 
