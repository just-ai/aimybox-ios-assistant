//
//  RootViewController.swift
//  AimyboxUI
//
//  Created by Vladislav Popovich on 26.12.2019.
//  Copyright © Just Ai. All rights reserved.
//

import Aimybox
import AimyboxUI

class RootViewController: UIViewController, AimyboxProvider {

    func aimybox() -> Aimybox? {
        let locale = Locale(identifier: "en")
        
        guard let speechToText = SFSpeechToText(locale: locale) else {
            fatalError("Locale is not supported.")
        }
        guard let textToSpeech = AVTextToSpeech(locale: locale) else {
            fatalError("Locale is not supported.")
        }
        
        let dialogAPI = AimyboxDialogAPI(api_key: "Ldf0j7WZi3KwNah2aNeXVIACz0lb9qMH",
                                         unit_key: UIDevice.current.identifierForVendor!.uuidString,
                                         route: URL(string: "https://bot.aimylogic.com/chatapi/webhook/zenbox/cVcGlsvz:800911b5cd537cba8c734e772f8c4a1ebd68fb1a")!)
        
        let config = AimyboxBuilder.config(speechToText, textToSpeech, dialogAPI)
        
        return AimyboxBuilder.aimybox(with: config)
    }

    @IBOutlet weak var aimyboxOpenButton: AimyboxOpenButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        aimyboxOpenButton.presenter = self
        
        AimyboxViewController.onViewDidLoad = { vc in

            let aimyboxView = vc.aimyboxView
            
            aimyboxView.provider = self
            aimyboxView.backgroundColor = .systemYellow
            aimyboxView.greetingText = "Hi, how can i help you?"
            aimyboxView.emptyRecognitionText = "Please, repeat..."
        }
    }
}
