//
//  DemoCell.swift
//  SlickDemo
//
//  Created by Matthew Sanford on 7/1/18.
//  Copyright © 2018 Matt Sanford. All rights reserved.
//

import Foundation
import UIKit
import SlickCollectionView

class DemoCell: SlickCell, ConfigurableCell {
    // Necessary for Slick Cell
    @IBOutlet weak var top: UIView!
    @IBOutlet weak var bottom: UIView!
    @IBOutlet weak var stack: UIStackView!
    
    @IBOutlet weak var title: UILabel!

    override func awakeFromNib() {
        super.stackView = stack
        super.bottomView = bottom
        super.topView = top
        setup()
    }
    // MARK: - ConfigurableCell
    func configure(_ item: DemoViewModel, at indexPath: IndexPath, delegate: CellInteractable, state: CellState) {
        self.title.text = item.title
        self.delegate = delegate
        self.indexPath = indexPath
    }

    @objc private func tapped() {
        delegate?.didTapTopView(cell: self)
    }

    private func setup() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped))
        topView.addGestureRecognizer(gestureRecognizer)
    }
}
