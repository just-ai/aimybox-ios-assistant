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
     Table view in which all responses and queries added.
     */
    private weak var tableView: UITableView!
    /**
     Clean View Model, uses `Aimybox` instance.
     */
    private var viewModel = AimyboxViewModel()
    
    override init (frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    func commonInit() {
        
        let tableView = UITableView()
        addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        setNeedsLayout()
        
        tableView.tableFooterView = UIView()
        tableView.dataSource = viewModel
        viewModel.onItemsUpdated = {
            tableView.reloadData()
        }
        tableView.estimatedRowHeight = 600
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(AimyboxTextCell.nib, forCellReuseIdentifier: AimyboxTextCell.identifier)
        tableView.register(AimyboxButtonsCell.nib, forCellReuseIdentifier: AimyboxButtonsCell.identifier)
        tableView.register(AimyboxImageCell.nib, forCellReuseIdentifier: AimyboxImageCell.identifier)
        tableView.register(AimyboxQueryCell.nib, forCellReuseIdentifier: AimyboxQueryCell.identifier)
        
        let button = UIButton()
        addSubview(button)
        button.setTitle("ME", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 60).isActive = true
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true
        button.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        button.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        button.addTarget(viewModel, action: #selector(AimyboxViewModel.onAssistantButtonTap), for: .touchUpInside)
        setNeedsLayout()
        
        self.tableView = tableView
    }
}
