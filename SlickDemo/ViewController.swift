//
//  ViewController.swift
//  SlickDemo
//
//  Created by Matt Sanford on 7/1/18.
//  Copyright © 2018 Matt Sanford. All rights reserved.
//

import UIKit
import SlickCollectionView

class ViewController: UIViewController {
    var collectionView: SlickCollection!
    var dataSource: DemoDataSource!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        collectionView = SlickCollection(parent: view, reuseIdentifier: "DemoCell")
        collectionView.registerNib(with: "DemoCell", bundle: Bundle.main)
        view.addSubview(collectionView)
        dataSource = setUpDataSource()
        setupCollectionView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setupCollectionView() {
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

// MARK: - Data Source
class DemoDataSource: CollectionArrayDataSource<DemoViewModel, DemoCell> {}

// MARK: - Private Methods
fileprivate extension ViewController {
    func setUpDataSource() -> DemoDataSource {
        let viewModels = (0..<32).map {
            return DemoViewModel(title: String($0))
        }
        let dataSource = DemoDataSource(collectionView: collectionView, array: viewModels)
        return dataSource
    }
}

