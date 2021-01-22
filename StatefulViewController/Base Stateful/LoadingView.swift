//
//  LoadingView.swift
//  StatefulViewController
//
//  Created by Hussein Work on 21/01/2021.
//

import UIKit

public class LoadingStateView: UIView {
        
    let activityIndicatorView: UIActivityIndicatorView = .init(style: .large)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    fileprivate func setup(){
        self.backgroundColor = .white
        
        addSubview(activityIndicatorView)
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.centerInSuperView()
        
        
        DispatchQueue.main.async {
            self.activityIndicatorView.startAnimating()
        }
    }
}
