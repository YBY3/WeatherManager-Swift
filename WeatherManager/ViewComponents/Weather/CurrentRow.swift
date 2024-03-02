//
//  CurrentRow.swift
//  WeatherManager
//
//  Created by Austen Radigk on 3/1/24.
//

import SwiftUI

struct CurrentRow: View {
    
    let viewModel: WeatherComponentViewModel
    
    var body: some View {
        
        let (temp, wind, icon, dayInfoData) = viewModel.getCurrentRowData()
    
        VStack(alignment: .leading, spacing: 5) {
            
            //Current Time
            Text(dayInfoData[1])
                .font(.system(size: 20))
            
            //Current Temp, Current Wind Speed, (Sunset/Sunrise Time)
            HStack {
                Spacer()
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .frame(width: 25, height: 10)
                Text(temp[0] + " " + temp[1])
                    .font(.system(size: 20))
                    .bold()
                Spacer()
                Image(systemName: "wind")
                    .font(.system(size: 20))
                    .frame(width: 25, height: 10)
                Text(wind[0] + " " + wind[1])
                    .font(.system(size: 20))
                    .bold()
                Spacer()
                Image(systemName: dayInfoData[0])
                    .font(.system(size: 20))
                    .frame(width: 25, height: 10)
                Text(dayInfoData[2])
                    .font(.system(size: 20))
                Spacer()
            }
            .frame(height: 40)
            .background(Color(UIColor.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 10))
        } //Main VStack End
        .foregroundColor(.green) //ADD System Color UI Setting
        .padding(.horizontal)
    }
}


//#Preview {
//    CurrentRow()
//}
