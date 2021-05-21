//
//  GlobalData.swift
//  EventSearch
//
//  Created by Jonathan Park on 5/21/21.
//

import Foundation

class GlobalData {
    static let shared = GlobalData()
    private let favoritesKey = "Favorites"
    
    var eventsList: [Event] = []
    var eventsDict: [Int: Event] = [:]
    var favorites: [String: String] = [:]
    
    func saveFavorites(id: Int, event: Event) {
        getFavorites()
        var changedEvent = event
        //If it already exists in the dictionary, it means the user is unfavoriting
        if let _ = favorites[String(id)] {
            favorites.removeValue(forKey: String(id))
            changedEvent.isFavorite = false
        } else {
            favorites.updateValue(" ", forKey: String(id))
            changedEvent.isFavorite = true
        }
        eventsDict.updateValue(changedEvent, forKey: id)
        UserDefaults.standard.set(favorites, forKey: favoritesKey)
    }
    
    func getFavorites() {
        favorites = UserDefaults.standard.object(forKey: favoritesKey) as? [String: String] ?? [:]
    }
    
    func getEventList(search: String, completionHandler: @escaping (_ events: [Event]?, _ error: String?) -> Void) {
        getFavorites()
        //If favorites are not empty and its a default search
        if !favorites.isEmpty && search == "" {
            var favoritesList = [String]()
            for favorite in favorites.keys {
                favoritesList.append(favorite)
            }
            EventsAPI.shared.getEventsWithId(ids: favoritesList) { events, errorMessage in
                guard let events = events else {
                    return
                }
                self.processEvents(events: events)
                completionHandler(self.eventsList, nil)
            }
        } else {
            //Fetch default list of events before user searches
            EventsAPI.shared.getEvents(search: search, completionHandler: { (events, errorMessage) in
                guard let events = events else {
                    return
                }
                self.processEvents(events: events)
                completionHandler(self.eventsList, nil)
            })
        }
    }
    
    //Put the events in dictionary format so it's easier to do lookups
    private func processEvents(events: [Event]) {
        var newList = [Event]()
        for event in events {
            if let _ = favorites[String(event.id)] {
                var favoriteEvent = event
                favoriteEvent.isFavorite = true
                newList.insert(favoriteEvent, at: 0)
                eventsDict.updateValue(favoriteEvent, forKey: event.id)
            } else {
                newList.append(event)
                eventsDict.updateValue(event, forKey: event.id)
            }
        }
        self.eventsList = newList
    }
    
    //Reload list with favorites on top
    func reloadEventList() {
        getFavorites()
        var events = [Event]()
        for event in eventsDict.values {
            if let _ = favorites[String(event.id)] {
                var favoriteEvent = event
                favoriteEvent.isFavorite = true
                events.insert(favoriteEvent, at: 0)
            } else {
                events.append(event)
            }
        }
        self.eventsList = events
    }
}
