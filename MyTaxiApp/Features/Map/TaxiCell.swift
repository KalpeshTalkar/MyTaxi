//
//  TaxiCell.swift
//  mytaxi
//
//  Created by Kalpesh Talkar on 03/10/19.
//  Copyright © 2019 Kalpesh Talkar. All rights reserved.
//

import UIKit

class TaxiCell: UICollectionViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var childView: UIView!
    @IBOutlet weak var taxiImageView: UIImageView!
    @IBOutlet weak var taxiLabel: UILabel!
    @IBOutlet weak var fleetTypeLabel: UILabel!
    @IBOutlet weak var directtionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        taxiImageView.applyShadow(false)
        childView.applyShadow()
        childView.backgroundColor = UIColor.white
        childView.cornerRadius(radius: UIConstants.cornerRadius())
        containerView.backgroundColor = UIColor.clear
    }
    
    override var isSelected: Bool {
        didSet {
            UIView.animate(withDuration: 0.3) {
                self.childView.backgroundColor = self.isSelected ? Color.lightGray : Color.white
                self.transform = self.isSelected ? CGAffineTransform(scaleX: 0.8, y: 0.8) : .identity
            }
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
//            UIView.animate(withDuration: 0.3) {
//                self.transform = self.isHighlighted ? CGAffineTransform(scaleX: 0.8, y: 0.8) : .identity
//            }
        }
    }
    
    func display(taxi: Taxi?) {
        taxiImageView.image = UIImage(named: "taxi")
        
        taxiLabel.layer.removeAllAnimations()
        fleetTypeLabel.layer.removeAllAnimations()
        directtionLabel.layer.removeAllAnimations()
        
        taxiLabel.alpha = 1
        fleetTypeLabel.alpha = 1
        directtionLabel.alpha = 1
        
        taxiLabel.textColor = UIColor.darkText
        fleetTypeLabel.textColor = UIColor.darkText
        directtionLabel.textColor = UIColor.darkText
        
        taxiLabel.backgroundColor = UIColor.clear
        fleetTypeLabel.backgroundColor = UIColor.clear
        directtionLabel.backgroundColor = UIColor.clear
        
        taxiLabel.text = "Taxi"
        fleetTypeLabel.text = "Fleet type: \(taxi?.fleetType ?? "-")"
        if taxi != nil {
            directtionLabel.text = "Heading: \(taxi!.getHeadingDirection())"
        } else {
            directtionLabel.text = "Heading: -)"
        }
    }
    
    func displayLoadingState() {
        taxiImageView.image = nil
        
        taxiLabel.textColor = Color.background()
        fleetTypeLabel.textColor = Color.background()
        directtionLabel.textColor = Color.background()
        
        taxiLabel.layer.removeAllAnimations()
        fleetTypeLabel.layer.removeAllAnimations()
        directtionLabel.layer.removeAllAnimations()
        
        taxiLabel.alpha = 1
        fleetTypeLabel.alpha = 1
        directtionLabel.alpha = 1
        
        taxiLabel.backgroundColor = Color.background()
        fleetTypeLabel.backgroundColor = Color.background()
        directtionLabel.backgroundColor = Color.background()
        
        UIView.animate(withDuration: 0.8, delay:0.0, options:[.allowUserInteraction, .curveEaseInOut, .autoreverse, .repeat], animations: {
            self.taxiLabel.alpha = 0
            self.fleetTypeLabel.alpha = 0
            self.directtionLabel.alpha = 0
        }, completion: nil)
    }
    
}
