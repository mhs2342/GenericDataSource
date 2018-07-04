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
    @objc open var stackView: UIStackView!
    @objc open var bottomView: UIView!
    @objc open var topView: UIView!

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

    func toggle() {
        stackView.spacing = isCollapsed() ? 0 : 15
        stackView.arrangedSubviews[expandedViewIndex].isHidden = isCollapsed()
    }

    private func isCollapsed() -> Bool {
        return state == .collapsed
    }

}

public enum CellState {
    case collapsed
    case expanded
}
