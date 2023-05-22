//
//  ContentView.swift
//  CpmAnalysis
//
//  Created by 김형관 on 2022/04/22.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var vm : CpmViewModel
    
    @State  var startDate: Int32 = 1
    @State var startDateText: String = "1"
    @State var idText: String = ""
    @State var nameText: String = ""
    @State var durationText: String = ""
    @State var predecessorsText: String = ""
    @State var successorsText: String = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                startDateTextSection
                idTextSection
                nameTextSection
                durationTextSection
                predecessorsTextSection
                successorsTextSection
                
                HStack {
                    
                    Button {
                        var tempPredecessors : [Int32] = []
                        var tempSuccessors : [Int32] = []
                        
                        guard !idText.isEmpty,
                              !durationText.isEmpty else {return}
                        
                        if !predecessorsText.isEmpty {
                            let tempString = predecessorsText
                            let stringArray = tempString.split(separator: " ")
                            for string in stringArray {
                                guard let temp = Int32(string) else {
                                    return
                                }
                                tempPredecessors.append(temp)
                            }
                        }
                        if !successorsText.isEmpty {
                            let tempString = successorsText
                            let stringArray = tempString.split(separator: " ")
                            for string in stringArray {
                                guard let temp = Int32(string) else {
                                    return
                                }
                                tempSuccessors.append(temp)
                            }
                        }
                        
                        if let idTemp = Int32(idText) {
                            if let temp = vm.savedActivities.first(where: {$0.id == idTemp}) {
                                temp.name = nameText
                                temp.duration = Int32(durationText) ?? 0
                                temp.predecessors = tempPredecessors
                                temp.successors = tempSuccessors
                            } else {
                                vm.addActivity(id: Int32(idText) ?? 0,
                                               name: nameText,
                                               duration: Int32(durationText) ?? 0,
                                               predecessors: tempPredecessors,
                                               successors: tempSuccessors)
                            }
                        }
                        
                    } label: {
                        Text("Save")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(height: 55)
                            .frame(maxWidth: .infinity)
                            .background(Color.pink)
                            .cornerRadius(10)
                        
                    }
                    .padding(.horizontal)
                    
                    NavigationLink(destination:
                                    CpmResultView()
                                    .environmentObject(vm)
                                   
                    ) {
                        Text("Schedule Calculate")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(height: 55)
                            .frame(maxWidth: .infinity)
                            .background(Color.pink)
                            .cornerRadius(10)
                    }.simultaneousGesture(TapGesture().onEnded{
                        if let startDateTemp = Int32(startDateText) {
                            startDate = startDateTemp
                        }
                        vm.project.scheduleCalculation(startDate: startDate)
                        startDateText = String(startDate)
                    })
                }
  
                List {
                    ForEach(vm.savedActivities) { activity in
                        Text("Activity id \(activity.id)")
                            .onTapGesture {
                                
                                idText = String(activity.id)
                                nameText = activity.name ?? ""
                                durationText = String(activity.duration)
                                
                                if let tempPredecessors = activity.predecessors {
                                    var tempStringPred = String()
                                    for predecessor in tempPredecessors {
                                        tempStringPred += String(predecessor) + " "
                                    }
                                    predecessorsText = tempStringPred
                                }
                                
                                if let tempSuccessors = activity.successors {
                                    var tempStringSucc = String()
                                    for successor in tempSuccessors {
                                        tempStringSucc += String(successor) + " "
                                    }
                                    successorsText = tempStringSucc
                                }
                                
                            }
                    }
                    .onDelete(perform: vm.deleteActivity)
                }
            }
            .listStyle(PlainListStyle())
        }
        .navigationTitle("Activity")
    }
  
    private var startDateTextSection: some View {
        HStack {
            Text("Start Date")
            
            TextField("start date", text: $startDateText)
                .font(.headline)
                .frame(height: 55)
                .background(Color.white)
                .cornerRadius(20)
                .padding(.horizontal)
                .padding(.leading)
        }

    }
    
    private var idTextSection: some View {
        TextField("id number", text: $idText)
            .font(.headline)
            .frame(height: 55)
            .background(Color.white)
            .cornerRadius(20)
            .padding(.horizontal)
            .padding(.leading)
    }
    
    private var nameTextSection: some View {
        TextField("name", text: $nameText)
            .font(.headline)
            .frame(height: 55)
            .background(Color.white)
            .cornerRadius(20)
            .padding(.horizontal)
            .padding(.leading)
    }
    
    private var durationTextSection: some View {
        TextField("duration", text: $durationText)
            .font(.headline)
            .frame(height: 55)
            .background(Color.white)
            .cornerRadius(20)
            .padding(.horizontal)
            .padding(.leading)
    }
    
    private var predecessorsTextSection: some View {
        TextField("predecessors", text: $predecessorsText)
            .font(.headline)
            .frame(height: 55)
            .background(Color.white)
            .cornerRadius(20)
            .padding(.horizontal)
            .padding(.leading)
        
    }
    
    private var successorsTextSection: some View {
        TextField("successors", text: $successorsText)
            .font(.headline)
            .frame(height: 55)
            .background(Color.white)
            .cornerRadius(20)
            .padding(.horizontal)
            .padding(.leading)
    }
    
}


//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
