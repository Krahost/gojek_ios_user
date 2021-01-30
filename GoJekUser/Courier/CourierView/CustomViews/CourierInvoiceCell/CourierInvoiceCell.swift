//
//  CourierInvoiceCell.swift
//  GoJekUser
//
//  Created by Apple on 06/01/21.
//  Copyright © 2021 Appoets. All rights reserved.
//

import UIKit

class CourierInvoiceCell: UITableViewCell {

    @IBOutlet weak var outterView: UIView!
    @IBOutlet weak var fareDetailsButton: UIButton!
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var locationPinImageView: UIImageView!
    @IBOutlet weak var deliveryHeadingLabel: UILabel!
    @IBOutlet weak var destinationAddressLabel: UILabel!
    @IBOutlet weak var recieverMobileLabel: UILabel!
    @IBOutlet weak var recieverNameLabel: UILabel!
    @IBOutlet weak var dropdownImageView: UIImageView!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var contentStackView: UIStackView!
    @IBOutlet weak var lengthView: UIView!
    @IBOutlet weak var packageTypeView: UIView!
    @IBOutlet weak var weightView: UIView!
    @IBOutlet weak var breadthView: UIView!
    @IBOutlet weak var heightView: UIView!
    @IBOutlet weak var instructionView: UIView!
    @IBOutlet weak var staticLengthLabel: UILabel!
    @IBOutlet weak var staticBreadthLabel: UILabel!
    @IBOutlet weak var staticWeightLabel: UILabel!
    @IBOutlet weak var staticHeightLabel: UILabel!
    @IBOutlet weak var staticPackageLabel: UILabel!
    @IBOutlet weak var staticDescriptionLabel: UILabel!
    @IBOutlet weak var lengthLabel: UILabel!
    @IBOutlet weak var breadthLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var packageLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    
    
    var isOpened = false {
        didSet{
            contentStackView.isHidden = !isOpened
            lineView.isHidden = !isOpened
            if isOpened{
                dropdownImageView.image = dropdownImageView.image?.rotate(radians: .pi)
            }
            else{
                dropdownImageView.image = UIImage(named: "drop-down-arrow")
            }
            self.mainStackView.layoutIfNeeded()

        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        initialLoads()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}



extension CourierInvoiceCell{
    private func initialLoads(){
        setFont()
        setText()
        setColor()
    }
    
    private func setFont(){
        recieverNameLabel.font = .setCustomFont(name: .medium, size: .x14)
        recieverMobileLabel.font = .setCustomFont(name: .medium, size: .x14)
        destinationAddressLabel.font = .setCustomFont(name: .medium, size: .x14)
        descriptionLabel.font = .setCustomFont(name: .medium, size: .x14)

        deliveryHeadingLabel.font = .setCustomFont(name: .bold, size: .x14)
        fareDetailsButton.titleLabel?.font = .setCustomFont(name: .bold, size: .x14)
        callButton.titleLabel?.font = .setCustomFont(name: .bold, size: .x14)
        
        staticLengthLabel.font = .setCustomFont(name: .bold, size: .x14)
        staticBreadthLabel.font = .setCustomFont(name: .bold, size: .x14)
        staticWeightLabel.font = .setCustomFont(name: .bold, size: .x14)
        staticHeightLabel.font = .setCustomFont(name: .bold, size: .x14)
        staticPackageLabel.font = .setCustomFont(name: .bold, size: .x14)
        staticDescriptionLabel.font = .setCustomFont(name: .bold, size: .x14)
        lengthLabel.font = .setCustomFont(name: .bold, size: .x14)
        breadthLabel.font = .setCustomFont(name: .bold, size: .x14)
        weightLabel.font = .setCustomFont(name: .bold, size: .x14)
        heightLabel.font = .setCustomFont(name: .bold, size: .x14)
        packageLabel.font = .setCustomFont(name: .bold, size: .x14)

    }
    
    private func setText(){
        deliveryHeadingLabel.text = "Delivery".uppercased()
        staticBreadthLabel.text = OrderConstant.breadth.localized
        staticHeightLabel.text = OrderConstant.height.localized
        staticWeightLabel.text = OrderConstant.weight.localized
        staticLengthLabel.text = OrderConstant.length.localized
        staticPackageLabel.text = CourierConstant.paymentType.localized
        staticDescriptionLabel.text = CourierConstant.instruction.localized
    }
    
    private func setColor(){
        deliveryHeadingLabel.textColor = .courierColor
        staticLengthLabel.textColor = .lightGray
        staticBreadthLabel.textColor = .lightGray
        staticWeightLabel.textColor = .lightGray
        staticHeightLabel.textColor = .lightGray
        staticPackageLabel.textColor = .lightGray
        staticDescriptionLabel.textColor = .lightGray
        
        lengthLabel.textColor = .darkGray
        breadthLabel.textColor = .darkGray
        weightLabel.textColor = .darkGray
        heightLabel.textColor = .darkGray
        packageLabel.textColor = .darkGray
        descriptionLabel.textColor = .darkGray
        
        locationPinImageView.setImageColor(color: .green)
        fareDetailsButton.tintColor = .courierColor
        callButton.tintColor = .courierColor
    }
}


extension UIImage {
    func rotate(radians: CGFloat) -> UIImage {
        let rotatedSize = CGRect(origin: .zero, size: size)
            .applying(CGAffineTransform(rotationAngle: CGFloat(radians)))
            .integral.size
        UIGraphicsBeginImageContext(rotatedSize)
        if let context = UIGraphicsGetCurrentContext() {
            let origin = CGPoint(x: rotatedSize.width / 2.0,
                                 y: rotatedSize.height / 2.0)
            context.translateBy(x: origin.x, y: origin.y)
            context.rotate(by: radians)
            draw(in: CGRect(x: -origin.y, y: -origin.x,
                            width: size.width, height: size.height))
            let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            return rotatedImage ?? self
        }

        return self
    }
}
