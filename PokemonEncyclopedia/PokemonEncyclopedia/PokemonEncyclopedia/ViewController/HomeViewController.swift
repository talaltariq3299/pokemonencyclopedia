//
//  HomeViewController.swift
//  PokemonEncyclopedia
//
//  Created by talal ahmad on 11/08/2021.
//

import UIKit

class HomeViewController: BaseTabSubViewController {
    public var pokemonArrayData : [Pokemon]  = []
    public var pokemonFilterArrayData : [Pokemon]  = []
    private var currentSorting:SortTypes = .numerically
    private var isFetchingData = false
    lazy var tableView : UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.separatorStyle = .none
        tv.showsVerticalScrollIndicator = false
        tv.backgroundColor = UIColor.white
        return tv
    }()
    var button = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
    lazy var optionsBtn: UIBarButtonItem = {
        button.setImage(UIImage(systemName: "ellipsis.circle", withConfiguration: SYSTEM_IMAGE_LARGE_CONFIG), for: .selected)
        button.setImage(UIImage(systemName: "ellipsis.circle", withConfiguration: SYSTEM_IMAGE_LARGE_CONFIG), for: .normal)
        var btn = UIBarButtonItem(customView: button)
        return btn
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        createView()
        tableViewSetup()
        title = "Pokemon"
        DISPATCH_MAIN_QUEUE.async {
            self.button.tintColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
            self.navigationController?.navigationBar.barStyle = .default
            self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)]
            let textAttributes = [NSAttributedString.Key.foregroundColor:#colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)]
            self.navigationController?.navigationBar.titleTextAttributes = textAttributes
        }
        
        self.navigationItem.rightBarButtonItem = optionsBtn
        if #available(iOS 14.0, *) {
            button.menu = createSortViewForMenu()
            button.showsMenuAsPrimaryAction = true
        } else {
//             Fallback on earlier versions
        }
        navigationController?.navigationBar.largeContentTitle = "Pokemon"
        navigationController?.navigationBar.prefersLargeTitles = true
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        searchController.searchBar.placeholder = "Search Pokemon"
        searchController.searchBar.semanticContentAttribute = .forceLeftToRight
        fetchPokemonData(withLoader: true)
        // Do any additional setup after loading the view.
    }
    func fetchPokemonData(withLoader: Bool = false){

        let offlineData = Pokemon.fetchFromStorage()
        if offlineData.count > 0 {
            self.pokemonArrayData.append(contentsOf: offlineData)
            self.isFetchingData = false
            self.tableView.tableFooterView = nil
            self.tableView.reloadData()
        }else{
            if withLoader {
                showSpinner(onView: view)
            }
            PokemonApiManager.shared.getRawPokemonListResult(offset: CONTENT_OFFSET, limit: MODEL_RESULT_LIMIT) { (response) in

            self.removeSpinner()
            self.isFetchingData = false
                
                switch response {
                case .success(let pokemons):
                    self.pokemonArrayData.append(contentsOf: pokemons)
                    DISPATCH_MAIN_QUEUE.async {
                        self.tableView.tableFooterView = nil
                        self.tableView.reloadData()
                    }
                case .badCode(let code):
                    DISPATCH_MAIN_QUEUE.async {
                        self.showToast(message: "BAD CODE: \(code)")
                    }
                case .invalid(let message):
                    DISPATCH_MAIN_QUEUE.async {
                        self.showToast(message: message)
                    }
                case .timeout(let message):
                    DISPATCH_MAIN_QUEUE.async {
                        self.showToast(message: message)
                    }
                case .faliure(let error):
                    DISPATCH_MAIN_QUEUE.async {
                        self.showToast(message: error.localizedDescription)
                    }
                    
                }
                
            }
        }
    }
    func showLoadingFooter(
        onView view     : UIView,
        withColor color : UIColor = UIColor.black) -> UIView {
        
        let footerView = UIView(
            frame: CGRect(
                x      : 0                ,
                y      : 0                ,
                width  : view.bounds.width,
                height : 80
            )
        )
        
        let spinner = UIActivityIndicatorView()
        
        spinner.style  = .medium
        spinner.center = footerView.center
        spinner.color  = color
        
        spinner.startAnimating()
        footerView.addSubview(spinner)
        
        return footerView
    }
    func createSortViewForMenu() -> UIMenu?{
        if #available(iOS 14.0, *) {
            let sortByName = UIAction(title: "Sort by Name", image: UIImage(named: "sort alphabatic")) { action in
                self.currentSorting = .alphabetically
                self.sort(modelData: self.pokemonArrayData, byType: self.currentSorting) { (results) in
                    self.pokemonArrayData = results
                    self.tableView.reloadData()
                }
                self.button.menu = self.createSortViewForMenu()
          }

            let sortByNumber = UIAction(title: "Sort by Number", image: UIImage(named: "sort numeric")) { action in
                self.currentSorting = .numerically
                self.sort(modelData: self.pokemonArrayData, byType: self.currentSorting) { (results) in
                    self.pokemonArrayData = results
                    self.tableView.reloadData()
                }
                self.button.menu = self.createSortViewForMenu()
          }

          let optionsFiles = UIMenu(title: "",options: [.displayInline], children: [sortByNumber,sortByName])
    
            if currentSorting == SortTypes.alphabetically {
                sortByName.state = .on
                sortByNumber.state = .off
            }else{
                sortByName.state = .off
                sortByNumber.state = .on
            }
       return UIMenu(options: [.displayInline], children: [optionsFiles])
        }else{
           return nil
        }
    }
     func sort(
        modelData data : [Pokemon] ,
        byType type    : SortTypes      ,
        completion     : @escaping (_ completeed: [Pokemon]) -> ()
    ) {
        var response : [Pokemon] = []
        
        switch type {
        case .alphabetically:
            response = data.sorted { datum1, datum2 in
                return datum1.name < datum2.name
            }
            completion(response)
        case .numerically:
            response = data.sorted { datum1, datum2 in
                return datum1.number?.intValue ?? 0 < datum2.number?.intValue ?? 0
                
            }
            completion(response)
            
        }
     }
    func search(text searchText: String, fromData data: [Pokemon]) -> [Pokemon] {
        return data.filter({
            $0.name.lowercased().contains(searchText.lowercased()) ||
                $0.number as! Int == Int(searchText) ?? 00 ||
                $0.detail!.abilities.contains(where: { $0.contains(searchText.lowercased())
        })
        })
    }
    func tableViewSetup(){
        tableView.delegate   = self
        tableView.dataSource = self
        
        tableView.register(
            PokemonTableViewCell.self,
            forCellReuseIdentifier: Constants.shared.PokemonCell
        )
    }
    func createView(){
        view.backgroundColor = UIColor.white
        
        ///Adding subview
        view.addSubview(tableView)
        //AddingConstraints
        setupConstraints()
        
    }
    func setupConstraints(){
        var tableViewConstraints = [NSLayoutConstraint]()
        tableViewConstraints = [
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor)                     ,
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 4.0)    ,
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)                   ,
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -4.0)
        ]
        
        NSLayoutConstraint.activate(tableViewConstraints)
    }
}
extension HomeViewController: UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         if isFiltering {
            return pokemonFilterArrayData.count
         }else{
            return pokemonArrayData.count
         }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: Constants.shared.PokemonCell
        ) as! PokemonTableViewCell
        
        let row = indexPath.row
        let pokenmonData = isFiltering ? pokemonFilterArrayData[row]:pokemonArrayData[row]
        cell.configure(withData: pokenmonData, atIndex: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        
        let detailsVC = DetailsVC()
        
        detailsVC.pokemonDataModel = isFiltering ? pokemonFilterArrayData[row]:pokemonArrayData[row]
        
        navigationController?.pushViewController(detailsVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
}

extension HomeViewController : UIScrollViewDelegate{

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == tableView {
            if !isFetchingData{
                if pokemonArrayData.count < 300 {
                    if ((scrollView.contentOffset.y + scrollView.frame.size.height + CGFloat(TABLEVIEWHEIGHT * 2) ) >= scrollView.contentSize.height) {
                        CONTENT_OFFSET += 10
                        isFetchingData = true

                        tableView.tableFooterView = showLoadingFooter(
                            onView: tableView
                        )
                        self.fetchPokemonData(withLoader: false)
                    }
                }
            }
        }
    }
}

extension HomeViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let keyStr = searchBar.text!
        pokemonFilterArrayData = search(text: keyStr, fromData: pokemonArrayData)
        self.tableView.reloadData()
        searchController.view.layoutIfNeeded()
        
    }
}

extension HomeViewController: UISearchControllerDelegate {
    
    func willDismissSearchController(_ searchController: UISearchController) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                self.tableView.reloadData()
                self.keyboardView.removeFromSuperview()
            })
            
        }
        
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        self.tableView.reloadData()
    }
}
