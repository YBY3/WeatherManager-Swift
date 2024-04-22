//
//  WeatherComponentViewModel.swift
//  WeatherManager
//
//  Created by Austen Radigk on 3/1/24.
//

import Foundation

protocol WeatherComponentViewModelProtocol: ObservableObject {

}


class WeatherComponentViewModel: WeatherComponentViewModelProtocol {
    private let forecastDataLoader: ForecastDataLoader
    private let weatherComponentUtils = WeatherComponentUtils()
    
    
    init(forecastData: ForecastData?) {
        forecastDataLoader = ForecastDataLoader(forecastData: forecastData)
    }
    
    
    //Gets CurrentRow with Data
    func getCurrentRow() -> CurrentRow {
        let sunData = weatherComponentUtils.getSunData(dayInfoList: forecastDataLoader.dayInfoList)
        let units = weatherComponentUtils.getUnits()
        let temp = weatherComponentUtils.convertTemp(kelvinData: forecastDataLoader.kelvinTempLists[0][0])
        let wind = weatherComponentUtils.convertWind(metricData: forecastDataLoader.windAvgLists[0][0])
        let icon = weatherComponentUtils.getConditionIcon(conditionInt: forecastDataLoader.conditionLists[0][0]) //ADD MORE DETAIL
        
        return CurrentRow(sunData: sunData, units: units, temp: temp, wind: wind, icon: icon)
    }
    
    
    //Gets ForecastRow with Data
    func getForecastRow(index: Int) -> ForecastRow {
        let date = forecastDataLoader.dateLists[index]
        let units = weatherComponentUtils.getUnits()
        let tempMin = weatherComponentUtils.convertTemp(kelvinData: forecastDataLoader.kelvinTempLists[5][index])
        let tempMax = weatherComponentUtils.convertTemp(kelvinData: forecastDataLoader.kelvinTempLists[6][index])
        let icon = weatherComponentUtils.getConditionIcon(conditionInt: forecastDataLoader.conditionLists[index].max()!) //ADD MORE DETAIL
        let precipitation_avg = weatherComponentUtils.smartAverage(list_item: forecastDataLoader.precipitationLists[index])
        let (graphScale, graphWidth, graphOffset) = horizontalGraphCalc(index: index)
        
        return ForecastRow(
            date: date,
            units: units,
            tempMin: tempMin,
            tempMax: tempMax,
            icon: icon,
            precipitation_avg: precipitation_avg,
            graphScale: graphScale,
            graphWidth: graphWidth,
            graphOffset: graphOffset
        )
    }
    
    
    
    //Horizontal Graph Calculator (WIP)
    func horizontalGraphCalc(index: Int) -> (Double, Double, Double) {
        let kelvinWeeklyMin = forecastDataLoader.kelvinTempLists[5].min()!
        let kelvinWeeklyMax = forecastDataLoader.kelvinTempLists[6].max()!
        let kelvinMin = forecastDataLoader.kelvinTempLists[5][index]
        let kelvinMax = forecastDataLoader.kelvinTempLists[6][index]
        
        let graph_scale = (kelvinWeeklyMax - kelvinWeeklyMin)
        let graph_width = (135 / graph_scale) * (kelvinMax - kelvinMin)
        if (kelvinMin - kelvinWeeklyMin) <= (kelvinWeeklyMax - kelvinMax) {
            let graph_offset_negative = -(((kelvinMin - kelvinWeeklyMin) + ((kelvinMax - kelvinMin) / 2)) - (graph_scale / 2))
            return (-graph_scale, graph_width, graph_offset_negative)
        }
        let graph_offset_positive = -(((kelvinWeeklyMax - kelvinMax) + ((kelvinMax - kelvinMin) / 2)) - (graph_scale / 2))
        
        return (graph_scale, graph_width, graph_offset_positive)
    }
    
    
    //Vertical Graph Calculator - [scale, dataList, dataMax, graphBaseLine (Enter 0 if Static)] (WIP)
    func verticalGraphCalc(data: [Double]) -> [Double] {
        let graphScale = data[0] / data[2]
        let graphBaseLine = (graphScale * data[3])
        if data[1] >= 0 {
            let graphHeight = graphScale * data[1]
            let graphOffset = (graphHeight / -2) - graphBaseLine
            return [graphHeight, graphOffset]
        }
        else {
            let graphHeight = graphScale * -data[1]
            let graphOffset = (graphHeight / 2) - graphBaseLine
            return [graphHeight, graphOffset]
        }
    }
}
