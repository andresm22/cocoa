//
//  MeetupCell.swift
//  CocoaHeadsNL
//
//  Created by Matthijs Hollemans on 25-05-15.
//  Copyright (c) 2015 Stichting CocoaheadsNL. All rights reserved.
//

import Foundation

private let dateFormatter = NSDateFormatter()

class MeetupCell: UITableViewCell {
    static let Identifier = "meetupCell"

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var logoImageView: PFImageView!
    @IBOutlet weak var dateContainer: UIView!
    @IBOutlet weak var calendarView: UIView!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var rsvpLabel: UILabel!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        titleLabel.text = ""
        timeLabel.text = ""
        dayLabel.text = ""
        monthLabel.text = ""

        logoImageView.file = nil
        logoImageView.image = UIImage(named: "MeetupPlaceholder")
    }

    func configureCellForMeetup(meetup: Meetup, row: Int) {
        titleLabel.text = meetup.name

        if let date = meetup.time {
            dateFormatter.dateStyle = .NoStyle
            dateFormatter.timeStyle = .ShortStyle
            let timeText = dateFormatter.stringFromDate(date)
            timeLabel.text = String(format: "%@ %@", meetup.location ?? "Location unknown", timeText)

            dateFormatter.dateFormat = "dd"
            dayLabel.text = dateFormatter.stringFromDate(date)

            dateFormatter.dateFormat = "MMM"
            monthLabel.text = dateFormatter.stringFromDate(date).uppercaseString

            if date.timeIntervalSinceNow > 0 {
                dayLabel.textColor = UIColor.blackColor()
                calendarView.backgroundColor = UIColorWithRGB(232, g: 88, b: 80)
                
        
                if let rsvpLimit = meetup.rsvp_limit?.intValue, let yesRsvp = meetup.yes_rsvp_count?.intValue {
                
                    rsvpLabel.text = "\(yesRsvp) CocoaHeads going"
                    
                    if rsvpLimit > 0 {
                        rsvpLabel.text = rsvpLabel.text! + "\n\(rsvpLimit - yesRsvp) seats available"
                    }
                }
            } else {
                dayLabel.textColor = UIColor(white: 0, alpha: 0.65)
                calendarView.backgroundColor = UIColorWithRGB(169, g: 166, b: 166)
                
                if let yesRsvp = meetup.yes_rsvp_count?.intValue {
                
                rsvpLabel.text = "\(yesRsvp) CocoaHeads had a blast"
                }
            }
        }

        if let logoFile = meetup.smallLogo {
            
            if let data = NSData(contentsOfURL: logoFile.fileURL) {
                self.logoImageView.image =  UIImage(data: data)!
                self.setNeedsLayout()
            }
        }
    }

    override func setHighlighted(highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        monthLabel.textColor = highlighted ? UIColor.blackColor() : UIColor.whiteColor()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        monthLabel.textColor = selected ? UIColor.blackColor() : UIColor.whiteColor()
    }
}
