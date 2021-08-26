//
//  PokemonTableViewCell.swift
//  Pokemon Encyclopedia
//
//  Created by talal ahmad on 11/08/2021.
//

import UIKit
import Combine
class PokemonTableViewCell: UITableViewCell {
    /* MARK:- AnyCancellable For Combines use  */
    var cancelAbleForDetail: AnyCancellable? = nil
    var cancelAbleForImage: AnyCancellable? = nil
    
    
    
    /* MARK:- Lazy Properties  */
    lazy var containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.layer.borderWidth  = 1.0
        view.layer.borderColor  = UIColor.black.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font      = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = UIColor.white
        label.numberOfLines = 1
        return label
    }()
    lazy var abilityHeadingUILabel: UILabel = {
        let label = UILabel()
        
        label.text      = "Abilities"
        label.font      = .boldSystemFont(ofSize: 18.0)
        label.textColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        return label
    }()
    lazy var pokemonRoundedImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "placeholder")
        
        imageView.clipsToBounds      = true
        imageView.layer.cornerRadius = 12
        imageView.layer.borderWidth  = 3.0
        imageView.layer.borderColor  = UIColor.white.cgColor
        
        imageView.backgroundColor = UIColor.clear
        
        return imageView
    }()
    lazy var abilityOneLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font               = UIFont.systemFont(ofSize: 14)
        label.textColor          = UIColor.white
        label.numberOfLines      = 2
        label.minimumScaleFactor = 0.8
        
        return label
    }()
    lazy var numberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = UIColor.white
        label.numberOfLines = 1
        return label
    }()
    
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        pokemonRoundedImageView.image = nil
    }
    
    func configure(withData data: Pokemon, atIndex index: Int){
        self.containerView.gradientBackground(from:#colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1) , to: #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1), direction: .leftToRight)
        pokemonRoundedImageView.image = nil
        if let pokemonDetail = data.detail {
            if let imageUrl = pokemonDetail.imageFileURL{
                let data = try! Data(contentsOf: imageUrl)
                self.pokemonRoundedImageView.image = UIImage(data: data)
            }else{
                cancelAbleForImage = pokemonDetail.$imageFileURL.sink { url in
                    // Handle new items
                    if let imageUrl = url{
                        let data = try! Data(contentsOf: imageUrl)
                        self.pokemonRoundedImageView.image = UIImage(data: data)
                    }
                }
            }
            if let number = data.number?.intValue{
                numberLabel.text = "#\(number)"
            }
            nameLabel.text   = data.name
            var abilities = ""
            for (index,ability) in pokemonDetail.abilities.enumerated(){
                if index < pokemonDetail.abilities.count - 1 {
                    abilities += ability + " , "
                }else{
                    abilities += ability
                }
                
            }
            abilityOneLabel.text   = abilities
            DISPATCH_MAIN_QUEUE.async {
                self.containerView.gradientBackground(from:#colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1) , to: #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1), direction: .leftToRight)
            }
        }else{
            
            cancelAbleForDetail =  data.publisher(for: \.detail).sink { detail in
                if let pokemonDetail = detail{
                    if let imageUrl = pokemonDetail.imageFileURL{
                        let data = try! Data(contentsOf: imageUrl)
                        self.pokemonRoundedImageView.image = UIImage(data: data)
                    }else{
                        
                        self.cancelAbleForImage = pokemonDetail.$imageFileURL.sink { url in
                            // Handle new items
                            if let imageUrl = url{
                                let data = try! Data(contentsOf: imageUrl)
                                self.pokemonRoundedImageView.image = UIImage(data: data)
                            }
                        }
                    }
                    DISPATCH_MAIN_QUEUE.async {
                        if let number = data.number?.intValue{
                            self.numberLabel.text = "#\(number)"
                        }
                        self.nameLabel.text   = data.name
                        var abilities = ""
                        for (index,ability) in pokemonDetail.abilities.enumerated(){
                            if index < pokemonDetail.abilities.count - 1 {
                                abilities += ability + " , "
                            }else{
                                abilities += ability
                            }
                            
                        }
                        self.abilityOneLabel.text   = abilities
                        self.containerView.gradientBackground(from:#colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1) , to: #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1), direction: .leftToRight)
                    }
                    
                }
                
            }
            
        }
        selectionStyle = .none
        if !self.subviews.contains(containerView) {
            ///Adding Subviews
            containerView.addSubview(pokemonRoundedImageView)
            containerView.addSubview(numberLabel)
            containerView.addSubview(nameLabel)
            containerView.addSubview(abilityHeadingUILabel)
            containerView.addSubview(abilityOneLabel)
            addSubview(containerView)
            ///Adding Constraints
            addConstraints()
        }
    }
    
    func addConstraints(){
        let imageWidthHeight = 100.0
        
        var containerViewConstraints = [NSLayoutConstraint]()
        var imageViewConstraints     = [NSLayoutConstraint]()
        var numberLabelConstraints    = [NSLayoutConstraint]()
        var nameLabelConstraints    = [NSLayoutConstraint]()
        var abilityHeadingLabelConstraints    = [NSLayoutConstraint]()
        var abilityLabelConstraints    = [NSLayoutConstraint]()
        
        containerViewConstraints = [
            containerView.topAnchor.constraint(equalTo: topAnchor,constant: 4.0)             ,
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8.0)    ,
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8.0) ,
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4.0)
        ]
        
        imageViewConstraints = [
            pokemonRoundedImageView.centerYAnchor.constraint(equalTo: centerYAnchor)                             ,
            pokemonRoundedImageView.heightAnchor.constraint(equalToConstant: CGFloat(imageWidthHeight))                   ,
            pokemonRoundedImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8.0),
            pokemonRoundedImageView.widthAnchor.constraint(equalToConstant: CGFloat(imageWidthHeight))
        ]
        numberLabelConstraints = [
            numberLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor,constant: 5),
            numberLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 5)            ,
            numberLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor) ,
        ]
        nameLabelConstraints = [
            nameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor,constant: 5),
            nameLabel.topAnchor.constraint(equalTo: numberLabel.bottomAnchor, constant: 5)            ,
            nameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor) ,
        ]
        
        abilityHeadingLabelConstraints = [
            abilityHeadingUILabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor,constant: 5),
            abilityHeadingUILabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 15)            ,
            abilityHeadingUILabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor) ,
        ]
        abilityLabelConstraints = [
            abilityOneLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor,constant: 5),
            abilityOneLabel.topAnchor.constraint(equalTo: abilityHeadingUILabel.bottomAnchor, constant: 5)            ,
            abilityOneLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor) ,
        ]
        
        NSLayoutConstraint.activate(containerViewConstraints + imageViewConstraints + numberLabelConstraints + nameLabelConstraints+abilityHeadingLabelConstraints+abilityLabelConstraints)
    }
}
