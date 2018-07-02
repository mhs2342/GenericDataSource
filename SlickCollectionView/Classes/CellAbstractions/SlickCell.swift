//
//  SlickCell.swift
//  GenericDataSource
//
//  Created by Matthew Sanford on 7/1/18.
//  Copyright © 2018 Matt Sanford. All rights reserved.
//

import Foundation
import UIKit

open class SlickCell: UICollectionViewCell {
    @IBOutlet weak var stackView: UIStackView!

    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var topView: UIView!

    public var delegate: CellInteractable?
    public var indexPath: IndexPath!
    let expandedViewIndex: Int = 1
    public static let expandedHeight: CGFloat = 240
    public static let collapsedHeight: CGFloat = 90

    var state: CellState = .collapsed {
        didSet {
            toggle()
        }
    }

    override open func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setup()
    }

    func toggle() {
        stackView.spacing = isCollapsed() ? 0 : 15
        stackView.arrangedSubviews[expandedViewIndex].isHidden = isCollapsed()
    }

    private func isCollapsed() -> Bool {
        return state == .collapsed
    }

    @objc private func tapped() {
        delegate?.didTapTopView(cell: self)
    }

    private func setup() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped))
        topView.addGestureRecognizer(gestureRecognizer)
    }

}

public enum CellState {
    case collapsed
    case expanded
}
