//
//  ViewState.swift
//  StatefulViewController
//
//  Created by Hussein Work on 21/01/2021.
//

import Foundation

public enum ViewStateType<ContentType> {
    case initial
    case hasContent(ContentType)
    case loading
    case empty(String)
    case failure(Error)
    
    var content: ContentType? {
        if case .hasContent(let content) = self {
            return content
        }
        
        return nil
    }
}
