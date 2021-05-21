//
//  HomeScreenEventTableViewCell.swift
//  EventSearch
//
//  Created by Jonathan Park on 5/20/21.
//

import UIKit

class HomeScreenEventTableViewCell: UITableViewCell {
    
    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var eventLocationLabel: UILabel!
    @IBOutlet weak var eventDateTimeLabel: UILabel!
    @IBOutlet weak var favoriteIcon: UIImageView!
    
    var event: Event?
    var isFavorite = false
    
    static let reuseIdentifier = "HomeScreenEventTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()

        setData()
    }
    
    func setData() {
        eventTitleLabel.text = ""
        eventLocationLabel.text = ""
        eventDateTimeLabel.text = ""
        
        if let event = event {
            if let date = event.localDateTime, let venue = event.venue, let timeZone = venue.timezone {
                let dateString = DateFormatterHelper.formatDate(date: date, timeZone: timeZone)
                eventTitleLabel.text = event.title
                eventLocationLabel.text = venue.name
                eventDateTimeLabel.text = dateString
                favoriteIcon.image = isFavorite ? UIImage(imageLiteralResourceName: "Filled-Star") : UIImage(imageLiteralResourceName: "Star")
            }
        }
    }
}
