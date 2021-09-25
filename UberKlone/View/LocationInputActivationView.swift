//
//  LocationInputActivationView.swift
//  UberKlone
//
//  Created by Eliu Efraín Díaz Bravo on 23/09/21.
//

import UIKit

protocol LocationInputActivationViewDelegate {
    func presentLocationInputView()
}

class LocationInputActivationView: UIView {
    //MARK: - Properties
    
    var delegate: LocationInputActivationViewDelegate?
    
    private let indicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    private let placeholderText: UIView = {
        let label = UILabel()
        label.text = "Where to?"
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .gray
        return label
    }()
    
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.55
        layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        layer.masksToBounds = false

        addSubview(indicatorView)
        indicatorView.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 16)
        indicatorView.setDimensions(width: 6, height: 6)
        
        addSubview(placeholderText)
        placeholderText.centerY(inView: self, leftAnchor: indicatorView.rightAnchor, paddingLeft: 20)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(presentLocationInputView))
        addGestureRecognizer(tap)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Handlers
    
    @objc func presentLocationInputView() {
        delegate?.presentLocationInputView()
    }
    
}
