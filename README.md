# SlickCollectionView

Short little framework to animate collectionview cells with a hidden drawer. 

![Demo](https://github.com/mhs2342/SlickCollectionView/blob/master/Slick.gif)

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
import SlickCollectionView
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

### Constraints
In order for the magic to happen you just need to apply 2 constraints to your stack view. 
  
1. The `topView` must have a height constraint with priority 999
2. The `bottomView` must have a height constraint of `<=` with priority 1000. 

Then just make sure that if your expanded and collapsed heights are anything other than `90` and `150` respectively, you set those properties somewhere before the delegate methods are called.

The reason this is, is because when the cells are loaded we want the top view only to be visible with a "rigid" height, and the bottom view to be 0. When they are tapped however we want the bottom view to expand, which causes a conflict with the top view height _unless_ we have set the priorty correctly so the autolayout engine will say "hey this bottom view constraint is more important right now so I am going to listen to it."

SlickCollection has no idea about your xib at the moment, so what you need to do is set the needed properties of `SlickCell` inside your custom cell in the `awakeFromNib` function. 

### DemoCell
```
class DemoCell: SlickCell, ConfigurableCell {
	// These will be used to connect SlickCell and your Cell
	@IBOutlet weak var top: UIView!
    @IBOutlet weak var bottom: UIView!
    @IBOutlet weak var stack: UIStackView!
	// any other outlets you like 
    @IBOutlet weak var title: UILabel!

    override func awakeFromNib() {
        super.stackView = stack
        super.bottomView = bottom
        super.topView = top
        // SlickCell.expandedHeight = topViewHeight + bottomViewHeight
        // SlickCell.collapsedHeight = topViewHeight
        setup()
    }

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
```
You can call your collectionview cell whatever you like as long as it is a subclass of `SlickCell` and conforms to the `ConfigurableCell` protocol.

The last thing you need to do is create a gesture recognizer on the top view of your cell and implement the handler which calls delegate. This will is what triggers the opening and closing effect of the cell.

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

