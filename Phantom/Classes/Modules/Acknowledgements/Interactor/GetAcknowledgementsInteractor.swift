//
//  GetAcknowledgementsInteractor.swift
//  Phantom
//
//  Created by Alberto Cantallops on 24/12/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import Foundation

class GetAcknowledgementsInteractor: Interactor<Any?, [Acknowledgement]> {

    var acknowledgementsResoursePath = Bundle.main.path(forResource: "Acknowledgements", ofType: "plist")

    override func execute(args: Any?) -> Result<[Acknowledgement]> {
        guard let acknowledgementsPlistPath = acknowledgementsResoursePath else {
                return .success([])
        }
        var acknowledgements: [Acknowledgement] = []
        if let plist = NSArray(contentsOfFile: acknowledgementsPlistPath) as? [[String: String]] {
            for dict in plist {
                if let title = dict["title"], let text = dict["text"] {
                    acknowledgements.append(Acknowledgement(name: title, text: text))
                }
            }
        }
        return .success(acknowledgements)
    }
}
