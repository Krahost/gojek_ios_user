//
//  XuberProviderReviewCell.swift
//  GoJekUser
//
//  Created by on 14/04/19.
//  Copyright © 2019 Appoets. All rights reserved.
//

import UIKit
import SDWebImage
class XuberProviderReviewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var reviewLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!


    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialLoads()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.profileImage.setRoundCorner()
    }
    
    func setValues(review: Review) {
        
   //   print( review.user?.picture)
    let pic = review.user?.picture
       if pic != "" && pic != nil {
//             if let imageUrl = URL(string: pic ?? "")  {
//            DispatchQueue.global().async {
//                let data = try? Data(contentsOf: imageUrl) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
//                DispatchQueue.main.async {
//                     self.profileImage.image = UIImage(data: data!)
//                }
//            }
//            }}
        
            if let imageUrl = URL(string: pic ?? "")  {
                 getData(from: imageUrl) { data, response, error in
                     guard let data = data, error == nil else { return }
                    // print(response?.suggestedFilename ?? imageUrl.lastPathComponent)
                     print("Download Finished")
                      let image = UIImage(data: data)
                     DispatchQueue.main.async() {
                        self.profileImage.image = image
                       // self.layoutSubviews()
                     }
                 }
            }
        }
        else {
            // Successful in loading image
             self.profileImage.image =  UIImage(named: Constant.userPlaceholderImage)
        }
        

//        self.profileImage.sd_setImage(with: URL(string: review.user?.picture ?? ""), placeholderImage: UIImage(named: Constant.userPlaceholderImage),options: SDWebImageOptions(rawValue: 0), completed: { (image, error, cacheType, imageURL) in
//                                        // Perform operation.
//                                        if (error != nil) {
//                                            // Failed to load image
//                                             self.profileImage.image = UIImage(named: Constant.userPlaceholderImage)
//                                        } else {
//                                            // Successful in loading image
//                                             self.profileImage.image = image
//                                        }
//                                    })
        if review.user_comment == "" {
            self.reviewLabel.text =  "No comment"
        } else {
            self.reviewLabel.text =  review.user_comment
        }
        self.nameLabel.text = (review.user?.firstName ?? "") + " " + (review.user?.lastName ?? "")
        self.ratingLabel.text = review.user_rating?.toString()
        self.dateLabel.text = review.created_at?.formatDateFromString(withFormat: DateFormat.ddmmyyyy)
    }
}

extension XuberProviderReviewCell {
    
    private func initialLoads() {
        reviewLabel.font = UIFont.setCustomFont(name: .light, size: .x14)
        dateLabel.font = UIFont.setCustomFont(name: .light, size: .x12)
        ratingLabel.font = UIFont.setCustomFont(name: .light, size: .x12)
        nameLabel.font = UIFont.setCustomFont(name: .medium, size: .x14)
        setDarkMode()
    }
    
    private func setDarkMode(){
          self.contentView.backgroundColor = .boxColor
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
           URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
       }
}
