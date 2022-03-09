//
//  TableViewCell.swift
//  APICall
//
//  Created by David on 09/03/2022.
//

import Foundation
import UIKit

class TableViewCell:UITableViewCell{
    
    var image = UIImageView(image: UIImage(systemName: "square.fill"))
    
    var label:UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = ""
        return lbl
    }()
    var label1:UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = ""
        return lbl
    }()
    var label2:UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = ""
        return lbl
    }()
   
    lazy var stack:UIStackView = {
        let lbl = UIStackView()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.axis = .horizontal
        return lbl
    }()
    lazy var stack1:UIStackView = {
        let lbl = UIStackView()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.axis = .vertical
        return lbl
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(stack1)
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
        label.text = ""
        label1.text = ""
    }
    
    func setData(staff: ModelValue) {
        label.text = staff.animeId
        label1.text = staff.animeName
        label2.text = staff.animeImg
        setupURLImage(imageURL: staff.animeImg)
    }
    
    func setUpUI() {
        self.contentView.addSubview(stack)
        stack.addArrangedSubview(image)
        stack.addArrangedSubview(stack1)
        stack.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10.0).isActive = true
        stack.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10.0).isActive = true
        stack.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10.0).isActive = true
        stack.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 10.0).isActive = true
        
        stack.alignment = .center
        stack.distribution = .fill
        stack.contentMode = .scaleToFill
        stack.spacing = 10.0
        stack.heightAnchor.constraint(greaterThanOrEqualToConstant: 60.0).isActive = true
        stack.setContentHuggingPriority(UILayoutPriority.init(rawValue: 251), for: NSLayoutConstraint.Axis.horizontal)
        
        image.translatesAutoresizingMaskIntoConstraints = false
        image.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10.0).isActive = true
        image.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10.0).isActive = true
        image.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10.0).isActive = true
        image.heightAnchor.constraint(equalToConstant: 100.0).isActive = true
        image.widthAnchor.constraint(equalToConstant: 100.0).isActive = true
        image.setContentHuggingPriority(UILayoutPriority.init(rawValue: 251), for: NSLayoutConstraint.Axis.horizontal)
        
//        stack1.addArrangedSubview(label)
        stack1.addArrangedSubview(label1)
//        stack1.addArrangedSubview(label2)
        stack1.leadingAnchor.constraint(equalTo: self.stack.trailingAnchor, constant: 10.0).isActive = true
        stack1.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10.0).isActive = true
        stack1.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10.0).isActive = true
        stack1.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10.0).isActive = true
        stack1.alignment = .leading
        stack1.distribution = .equalSpacing
        stack1.contentMode = .scaleAspectFit
        stack1.heightAnchor.constraint(greaterThanOrEqualToConstant: 60.0).isActive = true
        stack1.setContentHuggingPriority(UILayoutPriority.init(rawValue: 250), for: NSLayoutConstraint.Axis.horizontal)
      }
    
}
