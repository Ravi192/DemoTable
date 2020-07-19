//
//  countryCell.swift
//  Demo
//
//  Created by RAVIKANT KUMAR on 18/07/20.
//  Copyright © 2020 Ravikant Kumar. All rights reserved.
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
        countryImageView.topAnchor.constraint(equalTo: marginGuide.topAnchor).isActive = true
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor, constant: 60).isActive = true
        titleLabel.topAnchor.constraint(equalTo: marginGuide.topAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor).isActive = true
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont(name: "AvenirNext-DemiBold", size: 16)
        contentView.addSubview(detailLabel)
        detailLabel.translatesAutoresizingMaskIntoConstraints = false
        detailLabel.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor, constant: 60).isActive = true
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
    
    func setup(with title: String?, description: String?, imageName: String?) {
        titleLabel.text = title
        detailLabel.text = description
        countryImageView.downloaded(from: imageName ?? "")
        detailLabel.frame.size = detailLabel.intrinsicContentSize
        if description == nil {
            detailLabel.heightAnchor.constraint(equalToConstant: 13).isActive = true
        }
        countryImageView.widthAnchor.constraint(equalToConstant:detailLabel.frame.size.height + 20).isActive = true
        countryImageView.heightAnchor.constraint(equalToConstant:detailLabel.frame.size.height + 20).isActive = true
    }
    
    func cacheImageDownload(withData: Rows) {
        if let imageName = withData.imageHref {
            countryImageView.downloaded(from: imageName)
        }
    }
    
    
}


// MARK: - Image Download and load
extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        var indicator = UIActivityIndicatorView()
        indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 36, height: 36))
        indicator.style = UIActivityIndicatorView.Style.medium
        addSubview(indicator)
        indicator.startAnimating()
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else {
                    DispatchQueue.main.async() {
                        indicator.removeFromSuperview()
                    }
                    return
            }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
                indicator.removeFromSuperview()
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
