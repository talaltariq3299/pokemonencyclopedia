//
//  UIViewController+Ext.swift
//  Pokemon Encyclopedia
//
//  Created by talal ahmad on 11/08/2021.
//

import UIKit

extension UIViewController {
    
    /// Method to show the custom activity indicator
    /// - Parameters:
    ///   - view: on which the activity indicator is to be presented
    ///   - identifier: identifier for removing the spinner subview
    func showSpinner(
        onView view              : UIView              ,
        andIdentifier identifier : String   = "Default"
    ){
        let spinnerView = UIView(
            frame: UIScreen.main.bounds
        )
        
        spinnerView.backgroundColor         = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
        spinnerView.accessibilityIdentifier = identifier
        
        let spinner   = UIActivityIndicatorView(style: .large)
        spinner.color = UIColor.black
        spinner.translatesAutoresizingMaskIntoConstraints = false
        
        spinner.startAnimating()
        
        spinnerView.addSubview(spinner)
        spinner.centerXAnchor.constraint(equalTo: spinnerView.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: spinnerView.centerYAnchor).isActive = true
        
        view.addSubview(spinnerView)
        SPINNER.append(spinnerView)
    }
    
    /// Method to remove the custom activity indicator
    /// - Parameter identifier: identifier for removing the spinner subview
    func removeSpinner(withIdentifier identifier: String = "Default"){
        DISPATCH_MAIN_QUEUE.async {
            for (index, spinner) in SPINNER.enumerated() {
                if spinner.accessibilityIdentifier == identifier {
                    spinner.removeFromSuperview()
                    if SPINNER.indices.contains(index){
                        SPINNER.remove(at: index)
                    }
                }
            }
        }
    }
    
    /// Method to show toast
    /// - Parameters:
    ///   - message: Message to be displayed in tost
    ///   - font: font of the message
    func showToast(message : String, font: UIFont = UIFont.systemFont(ofSize: 14.0)) {
        let width = SCREEN_WIDTH * 0.8
        
        let toastLabel = UILabel(
            frame: CGRect(
                x      : (view.frame.size.width/2) - (width/2) ,
                y      : view.frame.size.height-70            ,
                width  : width                                 ,
                height : 35
            )
        )
        
        toastLabel.backgroundColor    = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
        toastLabel.textColor          = .black
        toastLabel.font               = font
        toastLabel.textAlignment      = .center
        toastLabel.text               = message
        toastLabel.alpha              = 1.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds      = true
        
        view.addSubview(toastLabel)
        toastLabel.bringSubviewToFront(view)
        
        UIView.animate(
            withDuration: 3.0          ,
            delay       : 0.1           ,
            options     : .curveEaseOut ,
            animations  : {
                
             toastLabel.alpha = 0.0
                
        }, completion: { (isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}
