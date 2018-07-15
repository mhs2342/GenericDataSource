//
//  SlickCollectionView.swift
//  GenericDataSource
//
//  Created by Matthew Sanford on 7/1/18.
//  Copyright © 2018 Matt Sanford. All rights reserved.
//

import Foundation
import UIKit

public class SlickCollection: UICollectionView {
    var parentView: UIView
    var reuseIdentifier: String
    open static var horizontalEdgeInset: CGFloat = 10
    open static var verticalEdgeInset: CGFloat = 10

    public init(frame: CGRect = .zero, parent: UIView, reuseIdentifier: String) {
        self.parentView = parent
        self.reuseIdentifier = reuseIdentifier
        super.init(frame: frame, collectionViewLayout: UICollectionViewFlowLayout())
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func registerNib(with name: String, bundle: Bundle?) {
        register(UINib.init(nibName: name, bundle: bundle), forCellWithReuseIdentifier: reuseIdentifier)
    }
}
