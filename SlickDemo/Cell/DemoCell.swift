//
//  DemoCell.swift
//  SlickDemo
//
//  Created by Matthew Sanford on 7/1/18.
//  Copyright © 2018 Matt Sanford. All rights reserved.
//

import Foundation
import UIKit
import GenericDataSource

class DemoCell: SlickCell, ConfigurableCell {

    @IBOutlet weak var title: UILabel!
    // MARK: - ConfigurableCell
    func configure(_ item: DemoViewModel, at indexPath: IndexPath, delegate: CellInteractable, state: CellState) {
        self.title.text = item.title
        self.delegate = delegate
        self.indexPath = indexPath
    }
}
