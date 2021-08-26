//
//  BaseTabSubViewController.swift
//  PokemonEncyclopedia
//
//  Created by talal ahmad on 11/08/2021.
//

import UIKit

class BaseTabSubViewController: UIViewController {
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool {
      return searchController.isActive && !isSearchBarEmpty
    }
    
    let keyboardView  = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width  , height: UIScreen.main.bounds.height))

    override func viewDidLoad() {
        super.viewDidLoad()

        searchController.searchBar.searchBarStyle = .minimal
        searchController.searchBar.sizeToFit()
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = true
        
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.definesPresentationContext = true
        
        self.navigationController?.setToolbarHidden(true, animated: false)
        let keyboardBtn = UIButton(frame: keyboardView.frame)
        keyboardBtn.addTarget(self, action: #selector(onClickKeyboardOutside), for: .touchUpInside)
        self.keyboardView.addSubview(keyboardBtn)
    }
    
    @objc func onClickKeyboardOutside() {
        self.searchController.isActive = false
    }
    
    func addConstraints() {
        view.addConstraint(NSLayoutConstraint(item: keyboardView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: keyboardView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0))

        view.addConstraint(NSLayoutConstraint(item: keyboardView, attribute: .top, relatedBy: .equal, toItem: self.view.safeAreaLayoutGuide, attribute: .bottom, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: keyboardView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute,multiplier: 1, constant: UIScreen.main.bounds.height))

    }
    
    func setSearchBarCancellButtonColor() {
        let attributes = [NSAttributedString.Key.foregroundColor : UIColor.red.cgColor]
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes(attributes, for: .normal)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension BaseTabSubViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 101 {
            textField.selectAll(nil)
        }
    }
}

extension BaseTabSubViewController: UIAdaptivePresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .fullScreen
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .fullScreen
    }
}

