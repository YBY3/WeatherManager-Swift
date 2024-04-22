//
//  DayInfoRow.swift
//  WeatherManager
//
//  Created by Austen Radigk on 3/5/24.
//

import SwiftUI

struct ForecastRow: View {
    let date: [String]
    let units: [String]
    let tempMin: String
    let tempMax: String
    let icon: String
    let precipitation_avg: String
    let graphScale: Double
    let graphWidth: Double
    let graphOffset: Double
    
    var body: some View {
        HStack {
            //Date
            Text(date[1])
                .font(.system(size: 20))
                .bold()
                .frame(width: 50, alignment: .center)
            
            //Precipitation
            VStack {
                Image(systemName: icon)
                    .font(.system(size: 20))
                Text(precipitation_avg+"%")
                    .font(.system(size: 15))
                    .bold()
            }
            .frame(width: 50, alignment: .center)
            
            //Weekly Temp Graph
            HStack {
                //Temp Min
                Text(tempMin)
                    .font(.system(size: 20))
                    .bold()
                    .frame(width: 45)
                
                //Temp Graph
                ZStack {
                    RoundedRectangle(cornerRadius: 3, style: .continuous)
                        .fill(.black)
                        .frame(width: 135, height: 12)
                    RoundedRectangle(cornerRadius: 3, style: .continuous) // Positive goes past boundairies!!!!
                        .fill(.green) //ADD System Color UI Setting
                        .frame(width: graphWidth, height: 10)
                        .offset(x: (135 / graphScale) * graphOffset)
                }
                .frame(width: 135)
            
                //Temp Max
                Text(tempMax)
                    .font(.system(size: 20))
                    .bold()
                    .frame(width: 45)
            }
        } //Main HStack End
        .foregroundColor(.green) //ADD System Color UI Setting
    }
}


#Preview {
    ForecastRow(
        date: ["", "Wed"],
        units: ["°F", "mph"],
        tempMin: "75",
        tempMax: "80",
        icon: "sun.max",
        precipitation_avg: "10",
        graphScale: 40,
        graphWidth: 40,
        graphOffset: 10
    )
}
