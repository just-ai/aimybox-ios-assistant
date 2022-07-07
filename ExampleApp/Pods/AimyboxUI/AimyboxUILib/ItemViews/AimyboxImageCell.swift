//
//  AimyboxImageCell.swift
//  sdk-sample-app
//
//  Created by Vladyslav Popovych on 22.12.2019.
//  Copyright © 2019 Just Ai. All rights reserved.
//

import UIKit
import SDWebImage

class AimyboxImageCell: UITableViewCell {
    /**
     Use this method to customize appearance of this cell.
     */
    public static var onAwakeFromNib: ((AimyboxImageCell) -> ())?
    /**
     Placeholder image that is used when image is loading.
     */
    public static var phImage: UIImage = UIImage(named: "placeholderimage",
                                                 in: Bundle(for: AimyboxImageCell.self),
                                                 compatibleWith: nil)!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .clear
        _imageView.layer.cornerRadius = 20.0
        _imageView.layer.masksToBounds = true
        
        type(of: self).onAwakeFromNib?(self)
    }
    
    public var item: AimyboxViewModelItem? {
        didSet {
            guard let _item = item as? AimyboxViewModel.ImageItem else {
                return
            }
            
            _imageView.sd_setImage(with: _item.image, placeholderImage: AimyboxImageCell.phImage) { [weak _imageView, _imageViewHeight](image, _, _, _) in
                let ratio = (image?.size.width ?? 1.0) / (image?.size.height ?? 1.0)
                let newHeight = Int((_imageView?.frame.width ?? 1.0) / ratio)
                
                _imageViewHeight?.constant = CGFloat(newHeight)
                _imageView?.isHidden = false
            }
        }
    }
    
    @IBOutlet weak var _imageViewHeight: NSLayoutConstraint!
    @IBOutlet weak var _imageView: SDAnimatedImageView!
    
    override func prepareForReuse() {
        _imageView.image = AimyboxImageCell.phImage
    }
    
    // MARK: - Internals
    
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: Bundle(for: AimyboxImageCell.self))
    }

    static var identifier: String {
        return String(describing: self)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: false)
    }
}
