//
//  PokemonDetailView.swift
//  Pokemon Encyclopedia
//
//  Created by talal ahmad on 11/08/2021.
//

import UIKit
import Combine
class PokemonDetailView: UIView {
    var cancelAbleForDetail: AnyCancellable? = nil
    /* MARK:- Properties  */
    public var pokemonModel: Pokemon? {
        didSet {
            populateDataOnViews()
        }
    }

    lazy var pokemonMainImageView: UIImageView = {
        let imageView = UIImageView()
                
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    lazy var horizontalLineLabel: UILabel = {
        let label = UILabel()

        label.backgroundColor = UIColor.white
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    lazy var stacViewkHr: [CustomStackView] = {
        var hr: [CustomStackView] = []
        for i in 0...5 {
            let stackView = CustomStackView(withAxis: .horizontal, Distribution: .fillEqually)
            
            stackView.backgroundColor = UIColor.white
            
            let heightAnchor = stackView.heightAnchor.constraint(equalToConstant: 2.0)
            heightAnchor.isActive = true
            
            hr.append(stackView)
        }
        return hr
    }()
    lazy var detailsStackView: CustomStackView = {
        let stackView = CustomStackView(withAxis: .vertical, Distribution: .fill, andSpacing: 4.0)
        
        stackView.addArrangedSubview(basicInfoHeaderStack)
        stackView.addArrangedSubview(numberStackView)
        stackView.addArrangedSubview(nameStackView)
        stackView.addArrangedSubview(heightStackView)
        stackView.addArrangedSubview(weightStack)
        stackView.addArrangedSubview(xpStack)
        stackView.addArrangedSubview(abilitiesHeaderStack)
        if let abilities = pokemonModel?.detail?.abilities{
            for (i,v) in abilities.enumerated() {
                stackView.addArrangedSubview(abilitiesStacks[i])
            }
        }
        return stackView
    }()
    ///ATTRIBUTES
    lazy var abilitiesHeadingLabelArray: [SmallUILabel] = {
        var labels: [SmallUILabel] = []
        
        if let abilities = pokemonModel?.detail?.abilities{
            for (i,_) in abilities.enumerated() {
            let label = SmallUILabel(withFont: UIFont.boldSystemFont(ofSize: 16.0))
            label.text = "#\(i+1):"
            labels.append(label)
        }
        }
        
        return labels
    }()
    lazy var abilitiesLabels: [SmallUILabel] = {
        var labels: [SmallUILabel] = []
        if let abilities = pokemonModel?.detail?.abilities{
        for i in abilities {
            let label = SmallUILabel()
            labels.append(label)
        }
        }
        return labels
    }()
    lazy var abilitiesStacks: [CustomStackView] = {
        var stacks: [CustomStackView] = []
        if let abilities = pokemonModel?.detail?.abilities{
            for (i,v) in abilities.enumerated() {
            let stackView = CustomStackView(withAxis: .horizontal, Distribution: .fillEqually)
            
            stackView.addArrangedSubview(abilitiesHeadingLabelArray[i])
            stackView.addArrangedSubview(abilitiesLabels[i])
            
            stacks.append(stackView)
        }
        }
        return stacks
    }()
    ///NUMBER
    lazy var numberStackView: CustomStackView = {
        let stackView = CustomStackView(withAxis: .horizontal, Distribution: .fillEqually)
        
        stackView.addArrangedSubview(numberHeadingUILabel)
        stackView.addArrangedSubview(numberUILabel)
        
        return stackView
    }()
    lazy var numberHeadingUILabel: SmallUILabel = {
        let label = SmallUILabel(withFont: UIFont.boldSystemFont(ofSize: 16.0))
        label.text = "Number:"
        return label
    }()
    lazy var numberUILabel: SmallUILabel = {
        let label = SmallUILabel()
        return label
    }()
    ///NAME
    lazy var nameStackView: CustomStackView = {
        let stackView = CustomStackView(withAxis: .horizontal, Distribution: .fillEqually)
        
        stackView.addArrangedSubview(nameHeadingUILabel)
        stackView.addArrangedSubview(nameLabel)
        
        return stackView
    }()
    lazy var nameHeadingUILabel: SmallUILabel = {
        let label = SmallUILabel(withFont: UIFont.boldSystemFont(ofSize: 16.0))
        label.text = "Name:"
        return label
    }()
    lazy var nameLabel: SmallUILabel = {
        let label = SmallUILabel()
        return label
    }()
 
    
    ///EXPERIIENCE
    lazy var xpStack: CustomStackView = {
        let stackView = CustomStackView(withAxis: .horizontal, Distribution: .fillEqually)
        
        stackView.addArrangedSubview(xpHeadingLabel)
        stackView.addArrangedSubview(xpLabel)
        
        return stackView
    }()
    lazy var xpHeadingLabel: SmallUILabel = {
        let label = SmallUILabel(withFont: UIFont.boldSystemFont(ofSize: 16.0))
        label.text = "Base Experience:"
        return label
    }()
    lazy var xpLabel: SmallUILabel = {
        let label = SmallUILabel()
        return label
    }()
    
    ///HEIGHT
    lazy var heightStackView: CustomStackView = {
        let stackView = CustomStackView(withAxis: .horizontal, Distribution: .fillEqually)
        
        stackView.addArrangedSubview(heightHeadingLabel)
        stackView.addArrangedSubview(heightLabel)
        
        return stackView
    }()
    lazy var heightHeadingLabel: SmallUILabel = {
        let label = SmallUILabel(withFont: UIFont.boldSystemFont(ofSize: 16.0))
        label.text = "Height:"
        return label
    }()
    lazy var heightLabel: SmallUILabel = {
        let label = SmallUILabel()
        return label
    }()
    ///WEIGHT
    lazy var weightStack: CustomStackView = {
        let stackView = CustomStackView(withAxis: .horizontal, Distribution: .fillEqually)
        
        stackView.addArrangedSubview(weightHeadingLabel)
        stackView.addArrangedSubview(weightLabel)
        
        return stackView
    }()
    lazy var weightHeadingLabel: SmallUILabel = {
        let label = SmallUILabel(withFont: UIFont.boldSystemFont(ofSize: 16.0))
        label.text = "Weight:"
        return label
    }()
    lazy var weightLabel: SmallUILabel = {
        let label = SmallUILabel()
        return label
    }()

    ///HEADERS
    lazy var basicInfoHeaderStack: CustomStackView = {
        let stackView = CustomStackView(withAxis: .horizontal, Distribution: .fillEqually)
        
        stackView.addArrangedSubview(basicInfoHeaderLabel)
        
        return stackView
    }()
    lazy var basicInfoHeaderLabel: SmallUILabel = {
        let label  = SmallUILabel(withFont: UIFont.boldSystemFont(ofSize: 24))
        label.text = "Basic Information"
        
        return label
    }()
    

    
    lazy var otherHeaderStack: CustomStackView = {
        let stackView = CustomStackView(withAxis: .horizontal, Distribution: .fillEqually)
        
        stackView.addArrangedSubview(otherHeaderLabel)
        
        return stackView
    }()
    lazy var otherHeaderLabel: SmallUILabel = {
        let label  = SmallUILabel(withFont: UIFont.boldSystemFont(ofSize: 20))
        label.text = "Other Info"
        
        return label
    }()
    lazy var abilitiesHeaderStack: CustomStackView = {
        let stackView = CustomStackView(withAxis: .horizontal, Distribution: .fillEqually)
    
        stackView.addArrangedSubview(abilitiesHeaderLabel)
        
        return stackView
    }()
    lazy var abilitiesHeaderLabel: SmallUILabel = {
        let label  = SmallUILabel(withFont: UIFont.boldSystemFont(ofSize: 24))
        label.text = "Abilities"
        
        return label
    }()
    /* MARK:- Initilizers  */
    convenience init(frame: CGRect, pokemonDatum: Pokemon? = nil) {
        self.init(frame: frame)
        self.pokemonModel =  pokemonDatum
        //make here what you want
        addSubViews()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
//        createView()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

/* MARK:- Methods */
extension PokemonDetailView {
    func populateDataOnViews(){

        if let imageUrl = pokemonModel?.detail?.imageFileURL{
                let data = try! Data(contentsOf: imageUrl)
                self.pokemonMainImageView.image = UIImage(data: data)
        }else{
            if let detail =  pokemonModel?.detail{
                cancelAbleForDetail = detail.publisher(for: \.imageFileURL) .sink { url in
                    // Handle new items
                    if let imageUrl = url{
                        let data = try! Data(contentsOf: imageUrl)
                        self.pokemonMainImageView.image = UIImage(data: data)
                    }
                }
                
            }
        }

        
        if let number = pokemonModel?.number {
            numberUILabel.text = "\(number)"
        }
        
        if let name = pokemonModel?.name {
            nameLabel.text   = name
        }
        
        if let abilities = pokemonModel?.detail?.abilities {
            for (index,_) in abilities.enumerated() {
                abilitiesLabels[index].text = abilities[index]
            }
        }
        
        if let height = pokemonModel?.detail?.height {
            heightLabel.text = "\(height)"
        }
        if let weight = pokemonModel?.detail?.weight {
            weightLabel.text = "\(weight)"
        }
        if let baseXP = pokemonModel?.detail?.baseExperience {
            xpLabel.text = "\(baseXP)"
        }
    }
    func setupConstraints(){
        var imageViewConstraints       = [NSLayoutConstraint]()
        var horizontalLineConstraints  = [NSLayoutConstraint]()
        var detailStackViewConstraints = [NSLayoutConstraint]()
        
        
        imageViewConstraints = [
            pokemonMainImageView.leadingAnchor.constraint(equalTo: leadingAnchor)            ,
            pokemonMainImageView.topAnchor.constraint(equalTo: topAnchor,constant: 50)          ,
            pokemonMainImageView.trailingAnchor.constraint(equalTo: trailingAnchor)          ,
            pokemonMainImageView.heightAnchor.constraint(equalToConstant: SCREEN_HEIGHT * 0.3)
        ]
        
        horizontalLineConstraints = [
            horizontalLineLabel.leadingAnchor.constraint(equalTo: leadingAnchor)            ,
            horizontalLineLabel.topAnchor.constraint(equalTo: pokemonMainImageView.bottomAnchor),
            horizontalLineLabel.trailingAnchor.constraint(equalTo: trailingAnchor)          ,
            horizontalLineLabel.heightAnchor.constraint(equalToConstant: 2.0)
        ]
        
        detailStackViewConstraints = [
            detailsStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16)   ,
            detailsStackView.topAnchor.constraint(equalTo: horizontalLineLabel.bottomAnchor)       ,
            detailsStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
        ]
        
        NSLayoutConstraint.activate(imageViewConstraints + horizontalLineConstraints + detailStackViewConstraints)
    }
    func addSubViews(){
        ///self
        backgroundColor = UIColor.white
        
        ///Adding subview
        addSubview(pokemonMainImageView)
        addSubview(horizontalLineLabel)
        addSubview(detailsStackView)
        //AddingConstraints
        setupConstraints()
    }
    

}
