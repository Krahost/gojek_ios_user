//
//  EtaView.swift
//  GoJekUser
//
//  Created by CSS on 22/06/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit

class EtaView: UIView {

    @IBOutlet weak var overView: UIView!
    @IBOutlet weak var etaTimeLabel: UILabel!
    @IBOutlet weak var etaLabel: UILabel!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialLoads()
    }
    private func initialLoads(){
        overView.setCornerRadius()
        self.etaLabel.text = Constant.eta
        self.etaLabel.textColor = .taxiColor
        self.etaLabel?.font = UIFont.setCustomFont(name: .medium, size: .x10)
        self.etaTimeLabel?.font = UIFont.setCustomFont(name: .medium, size: .x10)

    }
    
    override func layoutSubviews() {
        overView.addShadow(radius: 3.0, color: .appPrimaryColor)
        overView.setCornerRadius()

    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setETA(value : String) {
        etaTimeLabel.text = value
    }

}
