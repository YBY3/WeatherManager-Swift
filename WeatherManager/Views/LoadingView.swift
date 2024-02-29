//
//  LoadingView.swift
//  WeatherManager
//
//  Created by Austen Radigk on 2/14/24.
//

import SwiftUI

struct LoadingView: View {
    
    var body: some View {
        let _ = print("loadingview") //reloading test
        
        //Loading Icon
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle(tint: .white))
            .frame(maxWidth: .infinity, maxHeight: 25)
    }
}


#Preview {
    LoadingView()
}
