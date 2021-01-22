//
//  StatefulViewController.swift
//  StatefulViewController
//
//  Created by Hussein Work on 21/01/2021.
//

import UIKit

/**
 A ViewController type that manages it's content using state transitions, in which the content of the screen ( aka. Views ) belong to one ( or more ) of the given states ( see above ), this helps transition between loading, content, error and empty states without pain in the **.
 */
open class StatefulViewController<ContentType>: UIViewController {
    
    public typealias ViewState = ViewStateType<ContentType>
    
    
    public let emptyStateView: EmptyStateView = {
        return .init()
    }()
    
    public let failureStateView: FailureStateView = {
        return .init()
    }()
    
    public let loadingView: LoadingStateView = {
        return .init()
    }()
    
    
    /**
     The current state of the container
     */
    public fileprivate(set) var state: ViewState = .initial

    public override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if #available(iOS 13.0, *) {
            view.backgroundColor = UIColor.systemBackground
        } else {
            view.backgroundColor = .white
        }
        
        setupStatefulContent()
        setupViewsBeforeTransitioning()
        transition(to: .initial)
    }
    
    /**
        Override this method to setup the content view, this is preferred more than the viewDidLoad, as the container will make better choice for choosing views to be in the content state.
     */
    open func setupViewsBeforeTransitioning(){ }
    
    /**
     Transitions the content from one state to another
     */
    public func transition(to state: ViewState){
        let previousState = state
        
        self.willTransition(to: state)
        
        let viewsForGivenState = views(for: state)
        
        let baseView = self.view
        baseView?.subviews.forEach {
            self.unhighlight(view: $0)
        }
        
        viewsForGivenState.forEach {
            self.highlight(view: $0)
        }
        
        self.state = state
        
        switch state {
        case .loading:
            didTransitionToLoadingState()
            break
        case .failure(let error):
            didTransitionToFailureState(with: error)
            break
        case .empty(let message):
            didTransitionToEmptyState(with: message)
            break
        case .hasContent(let result):
            didTransitionToContentState(with: result)
            break
        default:
            break
        }
        
        self.didTransition(from: previousState)
    }
    
    open func retry(){
        
    }
    
    open func willTransition(to toState: ViewState){ }
    open func didTransition(from fromState: ViewState){ }
    
    
    //MARK: Mapping Views for States
    
    public func views(for state: ViewState) -> [UIView] {
        switch state {
        case .initial:
            return viewsForInitialState()
        case .hasContent:
            return viewsForContentState()
        case .empty:
            return viewsForEmptyState()
        case .loading:
            return viewsForLoadingState()
        case .failure:
            return viewsForFailureState()
        }
    }
    
    /// default returns the empty state view used
    open func viewsForEmptyState() -> [UIView] {
        return [emptyStateView]
    }
    
    /// default returns the failure state view
    open func viewsForFailureState() -> [UIView] {
        return [failureStateView]
    }
    
    /// default returns the loading state view
    open func viewsForLoadingState() -> [UIView] {
        return [loadingView]
    }
    
    /// default implementation returns the views in the content state, but without filling data
    open func viewsForInitialState() -> [UIView] {
        return viewsForContentState()
    }
    
    /// the default implementation of this method returns all the views except the one's used for other states.
    open func viewsForContentState() -> [UIView] {
        let otherViews = viewsForEmptyState() + viewsForFailureState() + viewsForLoadingState()
        let allViews = view.subviews
        
        let viewsForContentState = allViews.filter { !otherViews.contains($0) }
        return Array(viewsForContentState)
    }
    
    //MARK: Notify upon changing from state to another
        
    open func didTransitionToContentState(with result: ContentType) {
        /* called when the receiver transitions to hasContent state, and given the data result <R> */
    }
    
    open func didTransitionToFailureState(with error: Error) {
        self.failureStateView.subtitleLabel.text = error.localizedDescription
    }
    
    open func didTransitionToEmptyState(with message: String) {
        self.emptyStateView.subtitleLabel.isHidden = true
        self.emptyStateView.titleLabel.text = message
    }
    
    open func didTransitionToLoadingState() { }
}

extension StatefulViewController {
    fileprivate func setupStatefulContent(){
        [emptyStateView, failureStateView].forEach {
            view.addSubview($0)
            $0.pinToSafeArea()
        }
        
        view.addSubview(loadingView)
        loadingView.pinToSuperView()
        
        let retryBlock = { [unowned self] in
            self.retry()
        }
        
        emptyStateView.onButtonTap = retryBlock
        failureStateView.onButtonTap = retryBlock
    }
    
    // dimms the view alpha to 1, no, it hides the view
    fileprivate func unhighlight(view: UIView){
        view.isHidden = true
    }
    
    // brings the view to front, and set's it's alpha to 1
    fileprivate func highlight(view: UIView){
        view.isHidden = false
        view.superview?.bringSubviewToFront(view)
    }
}
