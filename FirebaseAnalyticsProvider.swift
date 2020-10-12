//
//  FirebaseAnalyticsProvider.swift
//  Library
//
//  Created by Deepika on 05/10/20.
//

import BehaviourAnalyzer
import FirebaseAnalytics

struct FirebaseAnalyticsProvider: AnalyticsProvider {
    var name: String = "FirebaseAnalytics"
    func trackEvent(_ event: AnalyticsEvent, parameters: [String : Any], userProperties: [String : String]) {
        Analytics.logEvent(event.name, parameters: parameters)
    }
    
    func trackScreen(withName screenName: String, parameters: [String : Any]) {
        
    }
    
    func setUserId(_ userId: String) {
        
    }
}
