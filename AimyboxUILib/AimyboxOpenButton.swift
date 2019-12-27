//
//  AimyboxOpenButton.swift
//  AimyboxUILib
//
//  Created by Vladislav Popovich on 26.12.2019.
//  Copyright © Just Ai. All rights reserved.
//

import UIKit

public class AimyboxOpenButton: UIView, UIViewControllerTransitioningDelegate {
    
    public weak var presenter: UIViewController?
    
    private let transition = CircularTransition()
    
    override init (frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        type(of: self).onInit?(self)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
        type(of: self).onInit?(self)
    }
    
    public static var onInit: ((AimyboxOpenButton) -> ())?
    
    private func commonInit() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(transitionToOpen))
        addGestureRecognizer(gesture)
    }
    
    @objc func transitionToOpen() {        
        let vc = AimyboxViewController()
        
        vc.transitioningDelegate = self
        vc.modalPresentationStyle = .custom
        vc.aimyboxView.backgroundColor = backgroundColor
        
        presenter?.present(vc, animated: true)
    }
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .present
        
        transition.startingPoint = center
        transition.circleColor = backgroundColor ?? .gray
        
        return transition
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .dismiss
        
        transition.startingPoint = center
        transition.circleColor = backgroundColor ?? .gray
        
        return transition
    }
}
