//
//  CustomStackView.swift
//  Pokemon Encyclopedia
//
//  Created by talal ahmad on 11/08/2021.
//

import UIKit

class CustomStackView: UIStackView {
    /* MARK:- Properties  */
    private var withAxis: NSLayoutConstraint.Axis
    private var withdistribution: UIStackView.Distribution
    private var andSpacing: CGFloat
    
    /* MARK:- Initilizers  */
    init(withAxis axis: NSLayoutConstraint.Axis, Distribution distributon: UIStackView.Distribution, andSpacing spacing: CGFloat = 0.0) {
        withAxis = axis
        withdistribution = distributon
        andSpacing = spacing
        super.init(frame: .zero)
        createView()
    }
    override init(frame: CGRect) {
        withAxis = .vertical
        withdistribution = .fill
        andSpacing = CGFloat(0.0)
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented yet")
    }

}

extension CustomStackView {
    func createView() {
        translatesAutoresizingMaskIntoConstraints = false
        axis          = withAxis
        spacing       = andSpacing
        alignment     = .fill
        distribution  = withdistribution
        clipsToBounds = true
    }
}
