//
//  WallpaperCell.swift
//  w07-2302700162
//
//  Created by umtlab03im11 on 19/3/26.
//

import UIKit

class WallpaperCell: UITableViewCell {
    
    @IBOutlet weak var wallpaperImageView: UIImageView!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        wallpaperImageView.contentMode = .scaleAspectFill
        wallpaperImageView.clipsToBounds = true
        userLabel.textColor = .white
        userLabel.font = UIFont.boldSystemFont(ofSize: 14)
        userLabel.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        userLabel.layer.cornerRadius = 4
        userLabel.clipsToBounds = true
    }
    
    func configure(with photo: Photo) {
        // Random height between 150 and 350
        let randomHeight = CGFloat.random(in: 150...350)
        imageHeightConstraint.constant = randomHeight
        
        wallpaperImageView.loadImage(from: photo.webformatURL, placeholder: UIImage(systemName: "photo"))
        userLabel.text = "  \(photo.user)  "
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        wallpaperImageView.image = nil
    }
}
