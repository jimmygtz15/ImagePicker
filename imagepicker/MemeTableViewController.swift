//
//  MemeTableViewController.swift
//  imagepicker
//
//  Created by Jimmy Gutierrez on 11/28/20.
//

import UIKit

class MemeTableViewController: UITableViewController {
    
    
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate as! AppDelegate
        let appDelegate = object
        return appDelegate.memes
    }
    
    @IBOutlet weak var navigationBar: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subscribeToMemeChangesNotifications()
        navigationBar.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        navigationBar.title = "Sent Memes"

    }

    
    @objc func reloadMemeData(_ notification: Notification) {
        print("reloading meme data")
        tableView.reloadData()
    }

    func subscribeToMemeChangesNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(reloadMemeData(_:)), name: NSNotification.Name.memeArrayChanged, object: nil)
    }
    
    @objc func addTapped() {
        let memeController = self.storyboard!.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        self.present(memeController, animated: true, completion: nil)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let myMeme = self.memes[(indexPath as NSIndexPath).row]
        cell.textLabel?.text = "\(myMeme.topText)...\(myMeme.bottomText)"
        cell.imageView?.image = myMeme.memedImage
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let memeDetailViewController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        let myMeme = self.memes[(indexPath as NSIndexPath).row]
        memeDetailViewController.memedImage = myMeme.memedImage
        self.navigationController!.pushViewController(memeDetailViewController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let rowHeight = (view.frame.size.height) / 5.0
        return rowHeight
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cell.responds(to: #selector(setter: UITableViewCell.separatorInset)) {
            cell.separatorInset = UIEdgeInsets.zero
        }
        if cell.responds(to: #selector(setter: UIView.preservesSuperviewLayoutMargins)) {
            cell.preservesSuperviewLayoutMargins = false
        }
        if cell.responds(to: #selector(setter: UIView.layoutMargins)) {
            cell.layoutMargins = UIEdgeInsets.zero
        }
    }

}
