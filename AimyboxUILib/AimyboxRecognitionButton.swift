//
//  AimyboxRecognitionButton.swift
//  AimyboxUILib
//
//  Created by Vladislav Popovich on 24.12.2019.
//  Copyright © 2019 NSI. All rights reserved.
//

import UIKit
import SDWebImage
import AimyboxCore

public class AimyboxRecognitionButton: UIView {
    /**
     Image when `Aimybox` in state of listening.
     */
    var listeningImage: UIImage = UIImage(named: "stop_image", in: Bundle(for: AimyboxRecognitionButton.self), compatibleWith: nil)!
    /**
     Image when `Aimybox` in state of listening.
     */
    var processingImage: UIImage = UIImage(named: "proc_image", in: Bundle(for: AimyboxRecognitionButton.self), compatibleWith: nil)!
    /**
     Image when `Aimybox` in state of processing.
     */
    var speakingImage: UIImage = UIImage(named: "stop_image", in: Bundle(for: AimyboxRecognitionButton.self), compatibleWith: nil)!
    /**
     Image when `Aimybox` in state of standby.
     */
    var standbyImage: UIImage = UIImage(named: "standby_image", in: Bundle(for: AimyboxRecognitionButton.self), compatibleWith: nil)!
    
    var imageView: SDAnimatedImageView?
    
    override init (frame: CGRect) {
        super.init(frame: frame)
        imageView = SDAnimatedImageView(frame: frame)
        commonInit()
        type(of: self).onInit?(self)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        imageView = SDAnimatedImageView(coder: aDecoder)
        commonInit()
        type(of: self).onInit?(self)
    }
    
    public static var onInit: ((AimyboxRecognitionButton) -> ())?
    
    private func commonInit() {
        addSubview(imageView ?? UIView())
        imageView?.translatesAutoresizingMaskIntoConstraints = false
        imageView?.topAnchor.constraint(equalTo: topAnchor).isActive = true
        imageView?.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        imageView?.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        imageView?.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        imageView?.image = standbyImage.insetted
        backgroundColor = .gray
    }
    
    public func update(by state: AimyboxState) {
        switch state {
        case .standby:
            imageView?.image = standbyImage.insetted
        case .listening:
            imageView?.image = listeningImage.insetted
        case .processing:
            imageView?.image = processingImage.insetted
        case .speaking:
            imageView?.image = speakingImage.insetted
        }
    }
    
    public func addTargetForTap(_ target: Any?, action: Selector) {
        let gesture = UITapGestureRecognizer(target: target, action: action)
        addGestureRecognizer(gesture)
    }
}


extension UIImage {
    var insetted: UIImage {
        self.withAlignmentRectInsets(
            .init(top: -15, left: -15, bottom: -15, right: -15)
        )
    }
}
