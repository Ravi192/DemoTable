//
//  countryCell.swift
//  Demo
//
//  Created by RAVIKANT KUMAR on 18/07/20.
//  Copyright © 2020 Societe Generale. All rights reserved.
//

import UIKit

class countryCell: UITableViewCell {
    
    let titleLabel = UILabel()
    let detailLabel = UILabel()
    
    let countryImageView:UIImageView = {
    let img = UIImageView()
    img.contentMode = .scaleAspectFill
    img.translatesAutoresizingMaskIntoConstraints = false
    img.layer.cornerRadius = 18
    img.clipsToBounds = true
    return img
    }()
    
    // MARK: Initalizers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let marginGuide = contentView.layoutMarginsGuide
        
        contentView.addSubview(countryImageView)
        countryImageView.leadingAnchor.constraint(equalTo:marginGuide.leadingAnchor, constant:10).isActive = true
        countryImageView.topAnchor.constraint(equalTo: marginGuide.topAnchor, constant: 10).isActive = true
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leadingAnchor.constraint(equalTo: countryImageView.trailingAnchor, constant: 10).isActive = true
        titleLabel.topAnchor.constraint(equalTo: marginGuide.topAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor).isActive = true
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont(name: "AvenirNext-DemiBold", size: 16)
        contentView.addSubview(detailLabel)
        detailLabel.translatesAutoresizingMaskIntoConstraints = false
        detailLabel.leadingAnchor.constraint(equalTo: countryImageView.trailingAnchor, constant: 10).isActive = true
        detailLabel.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor).isActive = true
        detailLabel.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor).isActive = true
        detailLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
        detailLabel.numberOfLines = 0
        detailLabel.font = UIFont(name: "Avenir-Book", size: 12)
        detailLabel.textColor = UIColor.lightGray
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
  var country:Rows? {
     didSet {
         guard let countryItem = country else {return}
        if let titleName = countryItem.title {
            titleLabel.text = titleName
        }
         if let descriptionName = countryItem.description {
             detailLabel.text = descriptionName
         }
         if let imageName = countryItem.imageHref {
            guard let imageUrl:URL = URL(string: imageName) else {
                return
            }
            countryImageView.loadImge(withUrl: imageUrl)
         }
        detailLabel.frame.size = detailLabel.intrinsicContentSize
        countryImageView.widthAnchor.constraint(equalToConstant:detailLabel.frame.size.height + 20).isActive = true
        countryImageView.heightAnchor.constraint(equalToConstant:detailLabel.frame.size.height + 20).isActive = true
     }
 }
    
    func cacheImageDownload(withData: Rows) {
         if let imageName = withData.imageHref {
            countryImageView.loadImageUsingCache(withUrl: imageName)
        }
    }
    

}


// MARK: - Image Download and load
let imageCache = NSCache<NSString, UIImage>()
extension UIImageView {
    func loadImge(withUrl url: URL) {
     var indicator = UIActivityIndicatorView()
     indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
     indicator.style = UIActivityIndicatorView.Style.medium
     indicator.center = self.center
     indicator.startAnimating()
        DispatchQueue.global().async { [weak self] in
            if let imageData = try? Data(contentsOf: url) {
                if let image = UIImage(data: imageData) {
                    DispatchQueue.main.async {
                     self?.image = image
                     indicator.removeFromSuperview()
                    }
                }
            }
        }
    }
    
    func loadImageUsingCache(withUrl urlString : String) {
        let url = URL(string: urlString)
        if url == nil {return}
        self.image = nil

        // check cached image
        if let cachedImage = imageCache.object(forKey: urlString as NSString)  {
            self.image = cachedImage
            return
        }

        let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView.init(style: UIActivityIndicatorView.Style.medium)
        addSubview(activityIndicator)
        activityIndicator.startAnimating()
        activityIndicator.center = self.center

        // if not, download image from url
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }

            DispatchQueue.main.async {
                if let image = UIImage(data: data!) {
                    imageCache.setObject(image, forKey: urlString as NSString)
                    self.image = image
                    activityIndicator.removeFromSuperview()
                }
            }

        }).resume()
    }
}
