//
//  EventsAPI.swift
//  EventSearch
//
//  Created by Jonathan Park on 5/20/21.
//

import Foundation
import Alamofire

class EventsAPI {
    private struct Endpoints {
        static let events = "/events"
        static let eventsWithId = "/events/%@"
    }
    
    static let shared = EventsAPI()
    private let perPage = "&per_page="
    private let perPageDefault = 25
    private let type = "&type="
    private let idPrefix = "&id="
    private let clientID = "?client_id=MjE5NzE2MTF8MTYyMTUzODM0OS40MDc5NzE2"
    private let baseURL = "https://api.seatgeek.com/2"
    
    func getEvents(search: String, completionHandler: @escaping (_ events: [Event]?, _ error: String?) -> Void) {
        let searchType = "\(type)\(search)"
        AF.request("\(baseURL)\(Endpoints.events)\(clientID)\(perPage)\(perPageDefault)\(searchType)", method: .get).response {
            (responseData) in
            guard let data = responseData.data else { return }
            do {
                let events = try JSONDecoder().decode(Events.self, from: data)
                completionHandler(events.events, nil)
            } catch {
                completionHandler(nil, error.localizedDescription)
            }
        }
    }
    
    func getEventsWithId(ids: [String], completionHandler: @escaping (_ events: [Event]?, _ error: String?) -> Void) {
        var idList = idPrefix
        for id in ids {
            idList.append(id)
            if id != ids.last {
                idList.append(",")
            }
        }
        AF.request("\(baseURL)\(Endpoints.events)\(clientID)\(perPage)\(perPageDefault)\(idList)", method: .get).response {
            (responseData) in
            guard let data = responseData.data else { return }
            do {
                let events = try JSONDecoder().decode(Events.self, from: data)
                completionHandler(events.events, nil)
            } catch {
                completionHandler(nil, error.localizedDescription)
            }
        }
    }
}
