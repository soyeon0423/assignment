//
//  CpmResultView.swift
//  CpmAnalysis
//
//  Created by 김형관 on 2022/04/26.
//

import SwiftUI

struct CpmResultView: View {
    @EnvironmentObject var vm: CpmViewModel
  
    
    var body: some View {
        ScrollView{
        Text(vm.project.result)
        }
    }

    
}

//struct CpmResultView_Previews: PreviewProvider {
//    static var previews: some View {
//        CpmResultView()
//    }
//}
