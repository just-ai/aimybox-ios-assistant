//
//  AImyboxViewModel.swift
//  AimyboxUILib
//
//  Created by Vladislav Popovich on 23.12.2019.
//  Copyright © Just Ai. All rights reserved.
//

import Foundation
import Aimybox

public class AimyboxViewModel: NSObject {

    public weak var provider: AimyboxProvider? {
        didSet {
            onProviderReceived()
        }
    }
    /**
     Text that shown on `Aimybox` start up.
     */
    public var greetingText: String? {
        willSet {
            if let _greetingText = newValue {
                items.append(
                    TextItem(_greetingText)
                )
            }
        }
    }
    /**
     */
    public var emptyRecognitionText: String = ""
    /**
     */
    public var shouldAutoStartRecognition: Bool = true
    /**
     Notifies `AimyboxView` to update itself.
     */
    public var onItemsUpdated: (()->())?
    /**
     User queries and aimybox responses.
     */
    private var items: [AimyboxViewModelItem] = [] {
        didSet {
            assistantDebouncer.debounce(delay: 0.25) { [weak self] in
                self?.onItemsUpdated?()
            }
        }
    }
    /**
     The only one strong reference.
     */
    private var aimybox: Aimybox? = nil
    
    private var userQueryItem: AimyboxViewModel.QueryItem?
    
    private var assistantDebouncer = DispatchDebouncer()
    
    @objc public func onAssistantButtonTap() {
        guard let _aimybox = aimybox else { return }
        
        assistantDebouncer.debounce(delay: 0.15) {
            if _aimybox.state != .standby {
                _aimybox.standby()
            } else {
                _aimybox.startRecognition()
            }
        }
    }
    
    public var onAimyboxStateChange: ((AimyboxState)->())?
    
    public func shutdown() {
        aimybox?.cancelSynthesis()
        aimybox?.standby()
    }
    
    deinit {
        aimybox?.standby()
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
        _aimybox.startRecognition()
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
                    AimyboxViewModel.ButtonsItem(buttons: response as! ButtonsReply) { [weak self] button in
                        if let _url = button.url {
                            UIApplication.shared.open(_url)
                        } else {
                            DispatchQueue.global().async {
                                self?.aimybox?.sendRequest(query: button.text)
                            }
                        }
                    }
                )
            }
        }
    }
}

// MARK: - AimyboxDelegate conformance.
extension AimyboxViewModel: AimyboxDelegate {

    public func aimybox(_ aimybox: Aimybox, willMoveFrom oldState: AimyboxState, to newState: AimyboxState) {
        onAimyboxStateChange?(newState)
    }
    
    public func stt(_ stt: SpeechToText, recognitionPartial result: String) {
        guard !result.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return
        }
        
        DispatchQueue.main.async { [weak self] in
            if self?.userQueryItem == nil {
                let item = AimyboxViewModel.QueryItem(text: result)
                self?.userQueryItem = item
                self?.items.append(item)
            }
            self?.userQueryItem?.text = result
            self?.onItemsUpdated?()
        }
    }
    
    public func stt(_ stt: SpeechToText, recognitionFinal result: String) {
        DispatchQueue.main.async { [weak self] in
            self?.userQueryItem?.text = result
            self?.onItemsUpdated?()
            self?.userQueryItem = nil
        }
    }

    public func sttRecognitionCancelled(_ stt: SpeechToText) {
        DispatchQueue.main.async { [weak self] in
            self?.userQueryItem = nil
        }
    }
    
    public func sttEmptyRecognitionResult(_ stt: SpeechToText) {
        DispatchQueue.main.async { [weak self] in
            self?.items.append(
                AimyboxViewModel.TextItem(self?.emptyRecognitionText ?? "")
            )
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
