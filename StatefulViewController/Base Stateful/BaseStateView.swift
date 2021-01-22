//
//  BaseStateView.swift
//  StatefulViewController
//
//  Created by Hussein Work on 21/01/2021.
//

import UIKit

public class BaseStateView: UIView {
    public let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.makeWidthEqualHeight()
        imageView.constraint(height: 180)
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        return imageView
    }()
    
    public let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = UIColor(named: "AccentColor")
        label.font = .boldSystemFont(ofSize: 18)
        return label
    }()
    
    public let subtitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    
    public let retryButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(white: 0.93, alpha: 1)
        button.setTitleColor(UIColor(named: "AccentColor"), for: .normal)
        button.setTitle("Retry", for: .normal)
        button.contentEdgeInsets = .init(top: 12, left: 35, bottom: 12, right: 35)
        button.clipsToBounds = true
        button.layer.cornerRadius = 6
        button.titleLabel?.font = .boldSystemFont(ofSize: 15)
        return button
    }()
    
    public var onButtonTap: (() -> Void)?
    
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    fileprivate func setup(){
        let stackView = UIStackView(arrangedSubviews: [imageView, titleLabel, subtitleLabel, retryButton])
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = 15
        stackView.setCustomSpacing(20, after: subtitleLabel)
        stackView.axis = .vertical
        
        stackView.setCustomSpacing(30, after: imageView)
        stackView.setCustomSpacing(30, after: subtitleLabel)
                
        addSubview(stackView)
        
        stackView.pinToSuperView(top: nil, left: 20, bottom: nil, right: -20)
        stackView.centerInSuperView()
        stackView.topAnchor.constraint(greaterThanOrEqualTo: topAnchor).isActive = true
        
        retryButton.clipsToBounds = true
        retryButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    @objc public func buttonTapped(){
        self.onButtonTap?()
    }
}
