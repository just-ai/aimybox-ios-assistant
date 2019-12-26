//
//  AimyboxButtonsCell.swift
//  sdk-sample-app
//
//  Created by Vladyslav Popovych on 22.12.2019.
//  Copyright © 2019 Just Ai. All rights reserved.
//

import UIKit

class AimyboxUIButton: UIButton {
    
    public static var onInit: ((AimyboxUIButton) -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        onInitDefault()
        type(of: self).onInit?(self)
        addTarget(self, action:#selector(self.buttonTap), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        onInitDefault()
        type(of: self).onInit?(self)
        addTarget(self, action:#selector(self.buttonTap), for: .touchUpInside)
    }
    
    private func onInitDefault() {
        layer.cornerRadius = 22
        layer.masksToBounds = true
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.darkGray.cgColor
        backgroundColor = .clear
    }
    
    public var onButtonTap: (()->())?
    
    @objc func buttonTap() {
        onButtonTap?()
    }
}

class AimyboxButtonsCell: UITableViewCell {
    /**
     Stack view in which buttons are injected.
     */
    @IBOutlet weak var mainStackView: UIStackView!
    /**
     Button height.
     */
    public var stackViewHeight: CGFloat = 44.0
    /**
     Distance between button rows.
     */
    public var stackVerticalSpacing: CGFloat = 16.0
    /**
     Leading contraint to content view.
     */
    public var stackViewLeading: CGFloat = 26.0
    /**
    Trailing contraint to content view.
    */
    public var stackViewTrailing: CGFloat = 26.0
    /**
    Top contraint to content view.
    */
    public var stackViewTop: CGFloat = 16.0
    /**
     
     */
    public var stackViewHorizontalSpacing: CGFloat = 20.0
    /**
     Max count of buttons in a row.
     */
    public var maxButtonCountInStackView: Int = 1
    /**
     Use this method to customize appearance of this cell.
     */
    public static var onAwakeFromNib: ((AimyboxButtonsCell) -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .clear
        layer.cornerRadius = 22.0
        layer.masksToBounds = true
        
        type(of: self).onAwakeFromNib?(self)
        
        mainStackView.constraints.forEach {
            mainStackView.removeConstraint($0)
        }
        
        mainStackView.spacing = stackViewHorizontalSpacing
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: stackViewLeading).isActive = true
        mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -stackViewTrailing).isActive = true
        mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: stackViewTop).isActive = true
        let constraint = mainStackView.heightAnchor.constraint(equalToConstant: stackViewHeight)
        constraint.priority = UILayoutPriority(rawValue: 750)
        constraint.isActive = true
    }
    
    public var item: AimyboxViewModelItem? {
        didSet {
            guard let _item = item as? AimyboxViewModel.ButtonsItem else {
                return
            }
            
            var currentStackView: UIStackView = mainStackView
            var limit = 0
            _item.buttons.forEach { button in
                if limit == maxButtonCountInStackView {
                    // Create new stack view
                    let oldStackView = currentStackView
                    currentStackView = newStackView(below: oldStackView)
                    createdStackViews.append(currentStackView)
                    limit = 0
                }
                
                let uiButton = AimyboxUIButton()
                uiButton.setTitle(button.text, for: .normal)
                uiButton.onButtonTap = {
                    _item.onButtonTap(button)
                }
                currentStackView.addArrangedSubview(uiButton)
                
                limit += 1
            }
            currentStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        }
    }

    // MARK: - Internals
    
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: Bundle(for: AimyboxButtonsCell.self))
    }

    static var identifier: String {
        return String(describing: self)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: false)
    }
    
    private var createdStackViews = [UIStackView]()
    
    private func newStackView(below view: UIView) -> UIStackView {
        let stackView = UIStackView(frame: mainStackView.bounds)
        stackView.alignment = mainStackView.alignment
        stackView.distribution = mainStackView.distribution
        stackView.axis = mainStackView.axis
        stackView.backgroundColor = view.backgroundColor
        stackView.layer.cornerRadius = view.layer.cornerRadius
        stackView.layer.masksToBounds = view.layer.masksToBounds
        stackView.spacing = mainStackView.spacing
        
        contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        let topConstraint = stackView.topAnchor.constraint(equalTo: view.bottomAnchor, constant: stackVerticalSpacing)
        topConstraint.priority = UILayoutPriority(rawValue: 750)
        topConstraint.isActive = true
        let heightConstraint = stackView.heightAnchor.constraint(equalToConstant: stackViewHeight)
        heightConstraint.priority = UILayoutPriority(rawValue: 750)
        heightConstraint.isActive = true
        return stackView
    }
    
    override func prepareForReuse() {
        
        mainStackView.arrangedSubviews.forEach {
            mainStackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }

        let stackView = UIStackView()
        stackView.alignment = mainStackView.alignment
        stackView.distribution = mainStackView.distribution
        stackView.axis = mainStackView.axis
        stackView.backgroundColor = mainStackView.backgroundColor
        stackView.layer.cornerRadius = mainStackView.layer.cornerRadius
        stackView.layer.masksToBounds = mainStackView.layer.masksToBounds
        stackView.spacing = mainStackView.spacing
        
        
        contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: stackViewLeading).isActive = true
        stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -stackViewTrailing).isActive = true
        stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: stackViewTop).isActive = true
        let constraint = stackView.heightAnchor.constraint(equalToConstant: stackViewHeight)
        constraint.priority = UILayoutPriority(rawValue: 750)
        constraint.isActive = true
        
        mainStackView.removeFromSuperview()
        mainStackView = stackView
        
        createdStackViews.forEach { view in
            view.arrangedSubviews.forEach {
                view.removeArrangedSubview($0)
                $0.removeFromSuperview()
            }
            view.removeFromSuperview()
        }
        createdStackViews.removeAll()
        
        contentView.layoutIfNeeded()
    }
}
