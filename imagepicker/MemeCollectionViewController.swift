//
//  MemeCollectionViewController.swift
//  imagepicker
//
//  Created by Jimmy Gutierrez on 11/28/20.
//

import UIKit
class MemeCollectionViewController: UICollectionViewController {
    @IBOutlet weak var navigationBar: UINavigationItem!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate as! AppDelegate
        let appDelegate = object
        return appDelegate.memes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subscribeToMemeChangesNotifications()
        navigationBar.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        navigationBar.title = "Sent Memes"
        let space: CGFloat = 3.0
        let dimensionWidth = (view.frame.size.width - (2 * space)) / 3.0
        let dimensionHeight = (view.frame.size.height - (2 * space) ) / 4.0
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimensionWidth, height: dimensionHeight)
         self.clearsSelectionOnViewWillAppear = false
    }
    
    @objc func reloadMemeData(_ notification: Notification) {
        collectionView.reloadData()
    }
    
    func subscribeToMemeChangesNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(reloadMemeData(_:)), name: NSNotification.Name.memeArrayChanged, object: nil)
    }
    
    @objc func addTapped() {
        let memeController = self.storyboard!.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        self.present(memeController, animated: true, completion: nil)
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCollectionViewCell", for: indexPath) as! MemeCollectionViewCell
        let myMeme = self.memes[(indexPath as NSIndexPath).row]
        cell.memeImageView?.image = myMeme.memedImage
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let memeDetailViewController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        let myMeme = self.memes[(indexPath as NSIndexPath).row]
        memeDetailViewController.memedImage = myMeme.memedImage
        self.navigationController!.pushViewController(memeDetailViewController, animated: true)
    }

}
