//
//  TableViewCell.swift
//  APICall
//
//  Created by David on 09/03/2022.
//

import Foundation
import UIKit

class AnimeListTableViewCell:UITableViewCell{
    
    var image = UIImageView()
    
    var animeName:UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = ""
        return lbl
    }()
   
    lazy var hStack:UIStackView = {
        let lbl = UIStackView()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.axis = .horizontal
        return lbl
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(hStack)
        setUpUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupURLImage(imageURL:String) {
        ImageDownloader.shared.getImage(url: imageURL) { [weak self] data in
            DispatchQueue.main.async {
                self?.image.image = UIImage(data: data)
            }
        }
    }
    
    override func prepareForReuse() {
        image.image = nil
        animeName.text = ""
    }
    
    func setData(data: AnimeValue) {
        animeName.text = data.animeName
        setupURLImage(imageURL: data.animeImg)
    }
    
    func setUpUI() {
        self.contentView.addSubview(hStack)
        hStack.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10.0).isActive = true
        hStack.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10.0).isActive = true
        hStack.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10.0).isActive = true
        hStack.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 10.0).isActive = true
        
        hStack.alignment = .center
        hStack.distribution = .fill
        hStack.contentMode = .scaleToFill
        hStack.spacing = 10.0
        hStack.heightAnchor.constraint(greaterThanOrEqualToConstant: 60.0).isActive = true
        hStack.setContentHuggingPriority(UILayoutPriority.init(rawValue: 251), for: NSLayoutConstraint.Axis.horizontal)
        
        hStack.addArrangedSubview(image)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10.0).isActive = true
        image.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10.0).isActive = true
        image.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10.0).isActive = true
        image.heightAnchor.constraint(equalToConstant: 100.0).isActive = true
        image.widthAnchor.constraint(equalToConstant: 100.0).isActive = true
        image.setContentHuggingPriority(UILayoutPriority.init(rawValue: 251), for: NSLayoutConstraint.Axis.horizontal)
        
        hStack.addArrangedSubview(animeName)
      }
    
}
