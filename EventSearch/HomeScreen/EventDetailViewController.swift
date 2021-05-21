//
//  EventDetailViewController.swift
//  EventSearch
//
//  Created by Jonathan Park on 5/20/21.
//

import Foundation
import UIKit

protocol EventDetailViewControllerDelegate: class {
    func favoriteButtonPressed(id: Int)
}

class EventDetailViewController: UIViewController {
    @IBOutlet private var eventImage: UIImageView!
    @IBOutlet private var dateTimeLabel: UILabel!
    @IBOutlet private var locationLabel: UILabel!
    @IBOutlet private var eventNameLabel: UILabel!
    @IBOutlet private var favoriteButton: UIButton!
    
    var eventId: Int?
    var event: Event?
    weak var delegate: EventDetailViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let eventId = eventId, let event = GlobalData.shared.eventsDict[eventId] {
            self.event = event
            setupUI(event: event)
        }
    }
    
    private func setupUI(event: Event) {
        if let performer = event.performers?.first, let imageUrl = performer.image {
            if let url = URL(string: imageUrl) {
                self.eventImage.af.setImage(withURL: url)
            }
        }
        
        if let venue = event.venue, let address = venue.address {
            locationLabel.text = address
            
            if let date = event.dateTimeUTC, let timeZone = venue.timezone {
                dateTimeLabel.text = DateFormatterHelper.formatDate(date: date, timeZone: timeZone)
            }
        }

        if let shortTitle = event.shortTitle {
            self.eventNameLabel.text = shortTitle
        } else {
            self.eventNameLabel.text = event.title
        }
        
        favoriteButton.isSelected = event.isFavorite ? true : false
        
        favoriteButton.setImage(UIImage(named: "Star"), for: .normal)
        favoriteButton.setImage(UIImage(imageLiteralResourceName: "Filled-Star"), for: .selected)
    }
    
    @IBAction func favoriteButtonPressed(_ sender: Any) {
        //Switch with filled star icon if possible
        favoriteButton.isSelected = !favoriteButton.isSelected
        
        if let event = event {
            GlobalData.shared.saveFavorites(id: event.id, event: event)
            delegate?.favoriteButtonPressed(id: event.id)
        }
    }
}
