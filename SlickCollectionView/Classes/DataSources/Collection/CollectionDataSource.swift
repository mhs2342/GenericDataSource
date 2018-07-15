//
//  CollectionDataSource.swift
//  GenericDataSource
//
//  Created by Andrea Prearo on 4/20/17.
//  Copyright © 2017 Andrea Prearo. All rights reserved.
//

import UIKit

public typealias CollectionItemSelectionHandlerType = (IndexPath) -> Void

open class CollectionDataSource<Provider: CollectionDataProvider, Cell: UICollectionViewCell>:
    NSObject,
    UICollectionViewDataSource,
    UICollectionViewDelegate,
    UICollectionViewDelegateFlowLayout
    where Cell: ConfigurableCell, Provider.T == Cell.T
{
    // MARK: - Delegates
    public var collectionItemSelectionHandler: CollectionItemSelectionHandlerType?

    // MARK: - Private Properties
    let provider: Provider
    let collectionView: SlickCollection
    var selectedIndexPaths = Set<IndexPath>()
    var hiddenIndexPaths: [IndexPath] = []

    // MARK: - Lifecycle
    init(collectionView: SlickCollection, provider: Provider) {
        self.collectionView = collectionView
        self.provider = provider
        super.init()
        setUp()
    }

    func setUp() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }

    // MARK: - UICollectionViewDataSource
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return provider.numberOfSections()
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return provider.numberOfItems(in: section)
    }

    open func collectionView(_ collectionView: UICollectionView,
         cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.reuseIdentifier,
            for: indexPath) as? Cell else {
            return UICollectionViewCell()
        }
        let item = provider.item(at: indexPath)
        if let item = item {
            let state: CellState = cellIsExpanded(at: indexPath) ? .expanded : .collapsed
            cell.configure(item, at: indexPath, delegate: self, state: state)
        }
        return cell
    }
    // MARK: - UICollectionViewDelegateFlowLayout

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let collectionView = collectionView as? SlickCollection {
            let width = collectionView.parentView.frame.width - (SlickCollection.horizontalEdgeInset * 2)
            if cellIsExpanded(at: indexPath) {
                return CGSize(width: width, height: SlickCell.exapndedHeight)
            } else {
                return CGSize(width: width, height: SlickCell.collapsedHeight)
            }
        }
        return CGSize.zero
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: SlickCollection.verticalEdgeInset,
                            left: SlickCollection.horizontalEdgeInset,
                            bottom: SlickCollection.verticalEdgeInset,
                            right: SlickCollection.horizontalEdgeInset)
    }
}

extension CollectionDataSource: CellInteractable {
    // Tap events are restricted to the top view so users can select the expanded view
    public func didTapTopView(cell: SlickCell) {
        if cell.state == .expanded {
            removeExpandedIndexPath(cell.indexPath)
            resizeCells(intiatedBy: cell, newState: .collapsed)
            self.unfocus()
        } else {
            addExpandedIndexPath(cell.indexPath)
            focusOn(cellWith: cell.indexPath)
            resizeCells(intiatedBy: cell, newState: .expanded)
        }
    }

    func focusOn(cellWith indexPath: IndexPath) {
        let hideable = collectionView.indexPathsForVisibleItems.filter({ $0 != indexPath })
            hideable.forEach({ self.collectionView.cellForItem(at: $0)?.isHidden = true
        })
        hiddenIndexPaths = hideable
    }

    func unfocus() {
        hiddenIndexPaths.forEach({ self.collectionView.cellForItem(at: $0)?.isHidden = false })
        hiddenIndexPaths = []
    }

    func resizeCells(intiatedBy cell: SlickCell, newState: CellState) {
        let duration = 0.3
        UIView.transition(with: collectionView, duration: duration, options: .curveEaseIn, animations: {
            self.collectionView.performBatchUpdates({
                self.collectionView.reloadData()
            })
        }) { (finished) in
            cell.state = newState
        }

    }

    fileprivate func cellIsExpanded(at IndexPath: IndexPath) -> Bool {
        return selectedIndexPaths.contains(IndexPath)
    }

    func addExpandedIndexPath(_ indexPath: IndexPath) {
        selectedIndexPaths.insert(indexPath)
    }

    func removeExpandedIndexPath(_ indexPath: IndexPath) {
        selectedIndexPaths.remove(indexPath)
    }
}
