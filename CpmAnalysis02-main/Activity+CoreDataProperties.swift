//
//  Activity+CoreDataProperties.swift
//  CpmAnalysis
//
//  Created by 김형관 on 2022/04/24.
//
//

import Foundation
import CoreData
import SwiftUI

extension Activity : Identifiable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Activity> {
        return NSFetchRequest<Activity>(entityName: "Activity")
    }

    @NSManaged public var earlyStart: Int32
    @NSManaged public var earlyFinish: Int32
    @NSManaged public var id: Int32
    @NSManaged public var name: String?
    @NSManaged public var duration: Int32
    @NSManaged public var lateStart: Int32
    @NSManaged public var lateFinish: Int32
    @NSManaged public var totalFloat: Int32
    @NSManaged public var freeFloat: Int32
    @NSManaged public var actualStart: Int32
    @NSManaged public var actualFinish: Int32
    @NSManaged public var predecessors: [Int32]?
    @NSManaged public var successors: [Int32]?
}


