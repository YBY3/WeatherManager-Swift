//
//  CurrentRow.swift
//  WeatherManager
//
//  Created by Austen Radigk on 3/1/24.
//

import SwiftUI

struct CurrentRow: View {
    let sunData: [String]
    let units: [String]
    let temp: String
    let wind: String
    let icon: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            //Current Time
            Text(sunData[0])
                .font(.system(size: 20))
            
            //Current Temp, Current Wind Speed, (Sunset/Sunrise Time)
            HStack {
                
                Spacer()
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .frame(width: 25, height: 10)
                Text(temp + " " + units[0])
                    .font(.system(size: 20))
                    .bold()
                Spacer()
                Image(systemName: "wind")
                    .font(.system(size: 20))
                    .frame(width: 25, height: 10)
                Text(wind + " " + units[1])
                    .font(.system(size: 20))
                    .bold()
                Spacer()
                Image(systemName: sunData[1])
                    .font(.system(size: 20))
                    .frame(width: 25, height: 10)
                Text(sunData[2])
                    .font(.system(size: 20))
                Spacer()
                
            }
            .frame(height: 40)
            .background(Color(UIColor.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            
        } //Main VStack
        .foregroundColor(.green) //ADD System Color UI Setting
        .padding(.horizontal)
    }
}


#Preview {
    CurrentRow(
        sunData: ["7:10 PM", "sunrise", "7:10 AM"],
        units: ["°F", "mph"],
        temp: "75",
        wind: "15",
        icon: "sun.max"
    )
}
