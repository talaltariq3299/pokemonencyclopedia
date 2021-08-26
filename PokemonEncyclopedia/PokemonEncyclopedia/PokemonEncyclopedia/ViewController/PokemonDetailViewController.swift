//
//  PokemonDetailViewController.swift
//  PokemonEncyclopedia
//
//  Created by talal ahmad on 11/08/2021.
//

import UIKit


class DetailsVC: UIViewController {

    /* MARK:- Properties */
    private var pokemonDetailsView: PokemonDetailView = PokemonDetailView()
    public var pokemonDataModel: Pokemon?
    
    /* MARK:- Life Cycle */
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        super.loadView()
        self.navigationController?.navigationBar.tintColor = .white
        pokemonDetailsView = PokemonDetailView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), pokemonDatum: pokemonDataModel)
        view = pokemonDetailsView
        if let pokemonDatum = pokemonDataModel {
            pokemonDetailsView.pokemonModel = pokemonDatum
        }
        DISPATCH_MAIN_QUEUE.async {
            self.pokemonDetailsView.gradientBackground(from:#colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1) , to: #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1), direction: .leftToRight)
        }
    }
    
    deinit {
    }
}
