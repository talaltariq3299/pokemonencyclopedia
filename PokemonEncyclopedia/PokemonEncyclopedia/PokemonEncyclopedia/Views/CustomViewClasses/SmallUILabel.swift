//
//  CustomLabel.swift
//  Pokemon Encyclopedia
//
//  Created by talal ahmad on 11/08/2021.
//

import UIKit

class SmallUILabel: UILabel {
    /* MARK:- Properties  */
    private var withFont: UIFont
    
    /* MARK:- Initilizers  */
    init(withFont font: UIFont) {
        withFont = font
        super.init(frame: .zero)
        createView()
    }
    override init(frame: CGRect) {
        withFont = UIFont.systemFont(ofSize: 16)
        super.init(frame: frame)
        createView()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented yet")
    }

}

extension SmallUILabel {
    func createView() {
        font          = withFont
        textColor     = UIColor.white
        textAlignment = .center
    }
}
