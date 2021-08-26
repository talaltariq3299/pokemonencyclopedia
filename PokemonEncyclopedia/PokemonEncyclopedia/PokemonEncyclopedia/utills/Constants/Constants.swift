//
//  Constants.swift
//  Pokemon Encyclopedia
//
//  Created by talal ahmad on 11/08/2021.
//

import Foundation
import UIKit


enum NetworkResponse {
    case success([Pokemon])
    case badCode(Int)
    case invalid(String)
    case timeout(String)
    case faliure(Error)
}

enum SortTypes: String {
    case alphabetically = "aplhabetically"
    case numerically    = "numerically"
}
/* MARK:- Constants */
var SPINNER           : [UIView] = []
let USER_DEFAULTS          = UserDefaults.standard
let DISPATCH_MAIN_QUEUE        = DispatchQueue.main
let APPDELEGATE       = UIApplication.shared.delegate as! AppDelegate
let SCENEDELEGATE     = SceneDelegate.shared
let SCREEN_WIDTH      = UIScreen.main.bounds.width
let SCREEN_HEIGHT     = UIScreen.main.bounds.height
let MODEL_RESULT_LIMIT      = 10
let TABLEVIEWHEIGHT = 130
var CONTENT_OFFSET: Int = 0
struct Constants {
    static let shared: Constants = Constants()
    
    ///TableView Cells
    let PokemonCell = "pokemonCell"
    
}

let SYSTEM_IMAGE_SMALL_CONFIG               = UIImage.SymbolConfiguration(scale: .small)
let SYSTEM_IMAGE_MEDIU_CONFIG               = UIImage.SymbolConfiguration(scale: .medium)
let SYSTEM_IMAGE_LARGE_CONFIG               = UIImage.SymbolConfiguration(scale: .large)

let SYSTEM_IMAGE_PAUSE_CONFIG               = UIImage.SymbolConfiguration(pointSize: 25, weight: .regular)
let SYSTEM_IMAGE_DEFULT_CONFIG_LIGHT        = UIImage.SymbolConfiguration(pointSize: 50, weight: .light)

let SYSTEM_IMAGE_ACTION_CONFIG              = UIImage.SymbolConfiguration(pointSize: 25, weight: .light)

let SYSTEM_IMAGE_POINT_CONFIG_20            = UIImage.SymbolConfiguration(pointSize: 20)
let SYSTEM_IMAGE_POINT_CONFIG_24            = UIImage.SymbolConfiguration(pointSize: 24)
let SYSTEM_IMAGE_POINT_CONFIG_35            = UIImage.SymbolConfiguration(pointSize: 35)
let SYSTEM_IMAGE_POINT_CONFIG_40            = UIImage.SymbolConfiguration(pointSize: 40)
let SYSTEM_IMAGE_POINT_CONFIG_50            = UIImage.SymbolConfiguration(pointSize: 50, weight: .light, scale: .large)
