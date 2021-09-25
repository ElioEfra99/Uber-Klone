//
//  LocationInputView.swift
//  UberKlone
//
//  Created by Eliu Efraín Díaz Bravo on 25/09/21.
//

import UIKit

protocol LocationInputViewDelegate {
    func dimsissLocationInputView()
}

class LocationInputView: UIView {
    
    //MARK: - Properties
    
    var delegate: LocationInputViewDelegate?
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "baseline_arrow_back_black_36dp").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleBackTapped), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        addShadow()
        
        addSubview(backButton)
        backButton.anchor(top: topAnchor, left: leftAnchor, paddingTop: 44, paddingLeft: 12, width: 24, height: 25)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers

    @objc func handleBackTapped() {
        delegate?.dimsissLocationInputView()
    }
    
    
    

}
