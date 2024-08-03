//
//  LiveActivityAgent.swift
//  HeyWeather
//
//  Created by Mohammad Yeganeh on 6/27/23.
//

import Foundation
import ActivityKit

///Added @available(iOS 16.1, *) to each function
///seperately ro be able to use the main class without limits

class LiveActivityAgent: ObservableObject {
    static let shared = LiveActivityAgent()
    @Published var activityPushTokenLoading: Bool = false
    @Published var activeActivityCity: City? = UserDefaults.get(for: .liveActivityTrackingCity)
    
    @available(iOS 16.1, *)
    func hasActiveActivity() -> Bool {
        return !Activity<LivePrecipitationAttributes>.activities.isEmpty
    }
    
    @available(iOS 16.1, *)
    func isTrackingCurrentCity() -> Bool {
        return hasActiveActivity() && activeActivityCity == CityAgent.getSelectedCity()
    }
    
    
    @available(iOS 16.1, *)
    func startPrecipitationActivity(precipitation: Precipitation, city: City){
        if hasActiveActivity() {
            return
        }
        let attributes = LivePrecipitationAttributes()
        
        
        let state = convertPrecipitationToAttribute(precipitation: precipitation)
        do {
            let precipitationActivity = try Activity<LivePrecipitationAttributes>.request(attributes: attributes, contentState: state, pushType: .token)
            UserDefaults.save(value: city, for: .liveActivityTrackingCity)
            activityPushTokenLoading = true
            Task { [weak self] in
                for await data in precipitationActivity.pushTokenUpdates {
                    let token = data.map {String(format: "%02x", $0)}.joined()
                    try await self?.sendLiveActivtyTokenToServer(token: token, end: false, city: city)
                    break
                }
                self?.activityPushTokenLoading = false
            }
        } catch let error {
            print(error.localizedDescription)
            self.activityPushTokenLoading = false
        }
    }
    
    func sendLiveActivtyTokenToServer(token: String, end: Bool, city: City) async throws {
        _ = try await Repository().sendLiveActivityToken(liveActivityToken: token, city: city, end: end)
    }
    @available(iOS 16.1, *)
    func stopAllActivities(city: City, completion: @escaping(() -> Void)) async{
        Task { [weak self] in
            for activity in Activity<LivePrecipitationAttributes>.activities{
                if let token = activity.pushToken?.map({String(format: "%02x", $0)}).joined() {
                    try await self?.sendLiveActivtyTokenToServer(token: token, end: true, city: city)
                }
                await activity.end(dismissalPolicy: .immediate)
            }
            self?.activeActivityCity = nil
            self?.activityPushTokenLoading = false
            
            completion()
        }
    }
    
    @available(iOS 16.1, *)
    private func convertPrecipitationToAttribute(precipitation: Precipitation) -> LivePrecipitationAttributes.ContentState{
        var firstNonZeroPrecipitation: PrecipitationChartData? = nil
        var firstZeroPrecipitation: PrecipitationChartData? = nil
        
        var isItRaining = false
        for i in 0..<precipitation.chartData.count {
            if i == 0 && precipitation.chartData[i].rate > 0 {
                isItRaining = true
            }
            if firstNonZeroPrecipitation == nil && precipitation.chartData[i].rate > 0 {
                firstNonZeroPrecipitation = precipitation.chartData[i]
            }
            if firstZeroPrecipitation == nil && precipitation.chartData[i].rate == 0 {
                firstZeroPrecipitation = precipitation.chartData[i]
            }
        }
        
        var relativeTime = 0
        let now = Date().timeIntervalSince1970
        if isItRaining {
            if firstZeroPrecipitation == nil {
                relativeTime = 0
            }else {
                let diff = Int(now - (firstZeroPrecipitation?.date.timeIntervalSince1970 ?? 0)) / 60
                relativeTime = -(abs(diff))
            }
        }else {
            let diff = Int(now - (firstNonZeroPrecipitation?.date.timeIntervalSince1970 ?? 0)) / 60
            relativeTime = abs(diff)
        }
        

        return LivePrecipitationAttributes.ContentState(
            currentIntensity: firstNonZeroPrecipitation?.rate ?? 0,
            relativeTime: relativeTime,
            startTime: precipitation.chartData.first?.date.timeIntervalSince1970 ?? 0,
            endTime: precipitation.chartData.last?.date.timeIntervalSince1970 ?? 0,
            currentTime: Date.now.timeIntervalSince1970,
            values: PrecipitationChartData.toSimpleItems(chartData: precipitation.chartData)
        )
    }
    
    
    
    
}
