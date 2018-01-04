//
//  AcknowledgementsView.swift
//  Phantom
//
//  Created by Alberto Cantallops on 24/12/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import UIKit

class AcknowledgementsView: TableViewController {
    override init(presenter: PresenterProtocol) {
        super.init(presenter: presenter)
        title = "Acknowledgements"
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
