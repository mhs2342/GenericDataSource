# SlickCollectionView

Short little framework to animate collectionview cells with a hidden drawer. 

## Getting Started

### Prerequisites

You are going to need Cocoapods.

```
$ sudo gem install cocoapods

```

### Installing

I created a pod for this framework and hope to evolve it into a robust framework for ~slick~ animations

```
pod install SlickCollection
```

Once you get the framework all buttoned up, you need to be sure to add the framework to your linked binaries. 

1. Go to project file 
2. Select General tab
3. Scroll to 'Linked Binaries and Frameworks'
4. Click the plus button and select SlickCollection

## Usage

At the top of whatever view controller you are using, just import the framework 
```
import SlickCollection
```
and you're ready to go! 

### Example from the SlickDemo

```
class ViewController: UIViewController {
    var collectionView: SlickCollection!
    var dataSource: DemoDataSource!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView = SlickCollection(parent: view, reuseIdentifier: "DemoCell")
        collectionView.registerNib(with: "DemoCell", bundle: Bundle.main)
        view.addSubview(collectionView)
        dataSource = setUpDataSource()
    }

	...
}
```
So first we initialize a SlickCollection with the view that will contain the collection, as well as the reuseIdentifier of the `.xib` you will create. *If it is wrong it will crash*. Then register that custom collectionview cell with your SlickCollection.

Next we setup the datasource. The awesome part of this is that the collection is totally generic so you can use whatever datasource you like as long as that type is wrapped in an array. We will see how to set that up in a moment.
```
class DemoDataSource: CollectionArrayDataSource<DemoViewModel, DemoCell> {}

extension ViewController {
    func setUpDataSource() -> DemoDataSource {
        let viewModels = (0..<32).map {
            return DemoViewModel(title: String($0))
        }
        let dataSource = DemoDataSource(collectionView: collectionView, array: viewModels)
        return dataSource
    }
}

```

All we are saying here is that the data source `DemoDataSource` knows about two kinds of things, a view model, which you define, and your slick cell that your registered with the collection view.

## Setting up your Custom SlickCollection cell
### Create a new File
1. File > New > File
2. Select Cocoa Touch Class
3. check 'Also Create XIB file'
4. Subclass of `SlickCell` (AutoComplete will not work here)

Now you should have a new .xib file and swift file.

### This part is a little tricky
The .xib is fairly straightforward, a stackview with a top and bottom view. I would recommend looking at, if not directly using the DemoCell.xib file here. Once you get the view laid out, you want to create outlets for them.

SlickCollection has no idea about your xib at the moment, so what you need to do is open the Assitant Editor, with Interface Builder on one side, and `SlickCell.swift` on the other. Since your Custom cell is a subclass of SlickCell, this is a totally legal move and makes sense. you want to create outlets for those that you see in `SlickCell.swift`. If you change the names, `it will not work` unless you change the names everywhere else so be careful.

The last step is take your auxillary views inside that xib, like images, labels, etc. and place those inside your newly created swift file as that is where your view model will be placed.

### DemoCell
```
class DemoCell: SlickCell, ConfigurableCell {
	// any other outlets you like 
    @IBOutlet weak var title: UILabel!

    func configure(_ item: DemoViewModel, at indexPath: IndexPath, delegate: CellInteractable, state: CellState) {
        self.title.text = item.title
        self.delegate = delegate
        self.indexPath = indexPath
    }
}
```
You can call your collectionview cell whatever you like as long as it is a subclass of `SlickCell` and conforms to the `ConfigurableCell` protocol.



The configure handler gets called by the `collectionView(_ collectionView: UICollectionView,
         cellForItemAt indexPath: IndexPath)` delegate method and does the work to 
         
         1. Get a view model from your data source
         2. Take that view model and drop it into your cell. 
Your custom cell is the one responsible for actually coordinating what goes where.


## Contributing

If you like SlickCollection and want to make it better, be my guest! Feel free to raise an issue or submit a PR.

## Authors

* **Matt Sanford** - *Initial work*


## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

* Andrea Prearo
* Aleksander Kania

