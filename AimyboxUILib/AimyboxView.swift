//
//  AimyboxViewController.swift
//  sdk-sample-app
//
//  Created by Vladyslav Popovych on 22.12.2019.
//  Copyright © 2019 Just Ai. All rights reserved.
//

import UIKit
import AimyboxCore

public protocol AimyboxProvider: class {
    /**
     If provider failed to create `Aimybox` instance, fallback screen will be displayed.
     */
    func aimybox() -> Aimybox?
}

@IBDesignable
public class AimyboxView: UIView {
    /**
     Provider is not retained.
     */
    public weak var provider: AimyboxProvider? {
        willSet {
            viewModel.provider = newValue
        }
    }
    /**
     Text that shown on `Aimybox` start up.
     */
    @IBInspectable
    public var greetingText: String = "" {
        willSet {
            viewModel.greetingText = newValue
        }
    }
    /**
     Text that shown when `Aimybox` could not recognize anything.
     */
    @IBInspectable
    public var emptyRecognitionText: String = "" {
        willSet {
            viewModel.emptyRecognitionText = newValue
        }
    }
    /**
     Determines when view will scroll it's content up.
     */
    @IBInspectable
    public var contentScrollOffset: CGFloat = 100.0
    /**
     Custom recognition button, default is nil.
     Set if you need update images dispayed.
     */
    public var recognitionButton: AimyboxRecognitionButton?
    /**
     Right, bottom offsets from parent view.
     */
    public var recognitionButtonLayoutOffsets: (right: CGFloat, bottom: CGFloat) = (30.0, 30.0)
    /**
     Table view in which all responses and queries added.
     */
    private weak var tableView: UITableView!
    /**
     Clean View Model, uses `Aimybox` instance.
     */
    private var viewModel = AimyboxViewModel()
    /**
     State of Aimybox.
     */
    public private(set) dynamic var state: AimyboxState = .standby
    /**
     To support observing.
     */
    @objc private dynamic var _state: Any = AimyboxState.standby
    
    
    override init (frame: CGRect) {
        super.init(frame: frame)
        let tableView = UITableView(frame: frame)
        commonInit(tableView: tableView)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        if let tableView = UITableView(coder: aDecoder) {
            commonInit(tableView: tableView)
        }
    }

    func commonInit(tableView: UITableView) {
        
        backgroundColor = .clear
        tableView.backgroundColor = .clear
        tableView.clipsToBounds = false
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        tableView.backgroundView = backgroundView
        
        tableView.separatorStyle = .none
        tableView.separatorColor = .clear

        tableView.tableFooterView = UIView()
        tableView.dataSource = viewModel
        viewModel.onItemsUpdated = { [weak self] in
            tableView.reloadData()
            self?.scrollToBottom(tableView: tableView)
        }
        viewModel.onAimyboxStateChange = { [weak self] _state in
            self?._state = _state
            self?.state = _state
        }
        tableView.estimatedRowHeight = 600
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(AimyboxTextCell.nib, forCellReuseIdentifier: AimyboxTextCell.identifier)
        tableView.register(AimyboxButtonsCell.nib, forCellReuseIdentifier: AimyboxButtonsCell.identifier)
        tableView.register(AimyboxImageCell.nib, forCellReuseIdentifier: AimyboxImageCell.identifier)
        tableView.register(AimyboxQueryCell.nib, forCellReuseIdentifier: AimyboxQueryCell.identifier)
        
        addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -contentScrollOffset).isActive = true
        tableView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        
        self.tableView = tableView
        
        // Recognition button
        
        var button: AimyboxRecognitionButton
        
        if let _recognitionButton = recognitionButton {
            button = _recognitionButton
        } else {
            button = AimyboxRecognitionButton()
            button.layer.cornerRadius = 30.0
            button.clipsToBounds = true
            button.translatesAutoresizingMaskIntoConstraints = false
            button.widthAnchor.constraint(equalToConstant: 60).isActive = true
            button.heightAnchor.constraint(equalToConstant: 60).isActive = true
        }
        
        addSubview(button)
        button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -recognitionButtonLayoutOffsets.bottom).isActive = true
        button.rightAnchor.constraint(equalTo: rightAnchor, constant: -recognitionButtonLayoutOffsets.right).isActive = true
        button.addTargetForTap(viewModel, action: #selector(AimyboxViewModel.onAssistantButtonTap))
        observations.append(
            observe(\._state) { (_view, value) in
                let newState = (_view._state as! AimyboxState)
                DispatchQueue.main.async {
                    button.update(by: newState)
                }
            }
        )
        setNeedsLayout()
    }
    
    private var observations: [NSKeyValueObservation] = []
    
    private func scrollToBottom(tableView: UITableView) {
        DispatchQueue.main.async {
            let numberOfSections =  tableView.numberOfSections - 1
            let numberOfRows = tableView.numberOfRows(inSection:  numberOfSections) - 1
            let indexPath = IndexPath(row: numberOfRows, section: numberOfSections)
            tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
}
