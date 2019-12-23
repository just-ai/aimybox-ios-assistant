//
//  AImyboxViewModel.swift
//  AimyboxUILib
//
//  Created by Vladislav Popovich on 23.12.2019.
//  Copyright © 2019 NSI. All rights reserved.
//

import Foundation
import AimyboxCore

public class AimyboxViewModel: NSObject {

    public weak var provider: AimyboxProvider? {
        didSet {
            onProviderReceived()
        }
    }
    public var onItemsUpdated: (()->())?
    /**
     User queries and aimybox responses.
     */
    private var items: [AimyboxViewModelItem] = [] {
        didSet {
            onItemsUpdated?()
        }
    }
    /**
     The only one strong reference.
     */
    private var aimybox: Aimybox? = nil
    
    private var userQueryItem: AimyboxViewModel.QueryItem?
    
    private var assistantButtonDebouncer = DispatchDebouncer()
    
    @objc public func onAssistantButtonTap() {
        guard let _aimybox = aimybox else { return }
        
        assistantButtonDebouncer.debounce(delay: 0.15) {
            if _aimybox.state != .standby {
                _aimybox.standby()
            } else {
                _aimybox.startRecognition()
            }
        }
    }
}

// MARK: - Internals

extension AimyboxViewModel {
    
    private func onProviderReceived() {
        guard let _provider = provider else {
            return
        }
        guard let _aimybox = _provider.aimybox() else {
            return
        }
        _aimybox.delegate = self
        
        aimybox = _aimybox
    }
    
    private func dispatchDAPIResponse(_ response: Response) {
        response.replies.forEach { response in
            if response is TextReply {
                items.append(
                    AimyboxViewModel.TextItem(text: response as! TextReply)
                )
            }
            if response is ImageReply {
                items.append(
                    AimyboxViewModel.ImageItem(image: response as! ImageReply)
                )
            }
            if response is ButtonsReply {
                items.append(
                    AimyboxViewModel.ButtonsItem(buttons: response as! ButtonsReply)
                )
            }
        }
    }
}

// MARK: - AimyboxDelegate conformance.
extension AimyboxViewModel: AimyboxDelegate {

    public func aimybox(_ aimybox: Aimybox, willMoveFrom oldState: AimyboxState, to newState: AimyboxState) {
        print("AAAAA", newState, "AAAAA")
    }
    
    public func sttRecognitionStarted(_ stt: SpeechToText) {
        let item = AimyboxViewModel.QueryItem(text: "")
        DispatchQueue.main.async { [weak self] in
            self?.userQueryItem = item
            self?.items.append(item)
        }
    }
    
    public func stt(_ stt: SpeechToText, recognitionPartial result: String) {
        DispatchQueue.main.async { [weak self] in
            print(result)
            self?.userQueryItem?.text = result
            self?.onItemsUpdated?()
        }
    }
    
    public func stt(_ stt: SpeechToText, recognitionFinal result: String) {
        DispatchQueue.main.async { [weak self] in
            print(result)
            self?.userQueryItem?.text = result
            self?.onItemsUpdated?()
        }
    }
    
    public func dialogAPI(received response: Response) {
        DispatchQueue.main.async { [weak self] in
            self?.dispatchDAPIResponse(response)
            self?.onItemsUpdated?()
        }
    }
}

// MARK: - UITableViewDataSource conformance.

extension AimyboxViewModel: UITableViewDataSource {
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section].rowCount
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.section]
        switch item.type {
        case .text:
            if let cell = tableView.dequeueReusableCell(withIdentifier: AimyboxTextCell.identifier, for: indexPath) as? AimyboxTextCell {
                cell.item = item
                return cell
            }
        case .buttons:
            if let cell = tableView.dequeueReusableCell(withIdentifier: AimyboxButtonsCell.identifier, for: indexPath) as? AimyboxButtonsCell {
                cell.item = item
                return cell
            }
        case .image:
            if let cell = tableView.dequeueReusableCell(withIdentifier: AimyboxImageCell.identifier, for: indexPath) as? AimyboxImageCell {
                cell.item = item
                return cell
            }
        case .query:
            if let cell = tableView.dequeueReusableCell(withIdentifier: AimyboxQueryCell.identifier, for: indexPath) as? AimyboxQueryCell {
                cell.item = item
                return cell
            }
        }
        return UITableViewCell()
    }
}
