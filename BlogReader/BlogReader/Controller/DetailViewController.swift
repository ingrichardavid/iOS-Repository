//
//  DetailViewController.swift
//  BlogReader
//
//  Created by Ing. Richard José David González on 26/1/16.
//  Copyright © 2016 Ing. Richard J. David G. All rights reserved.
//

import UIKit

/**
    The detail view controller to manage the blog articles.
*/
class DetailViewController: UIViewController {
    
    //MARK: - Connecting elements storyboard: IBOutlet.
    
    @IBOutlet weak var webView: UIWebView!
    
    //MARK: - Objects, Variables and Constants.
    
    ///Detail item.
    var detailItem: AnyObject? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    //MARK: - Methods: UIViewController.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Methods: Self.
    
    ///Method to load data in the view.
    func configureView() {
        // Update the user interface for the detail item.
        if let detail = self.detailItem {
            if let postWebView = self.webView {
                postWebView.loadHTMLString(detail.valueForKey("content")!.description, baseURL: NSURL(string: "https://googleblog.blogspot.com/"))
            }
        }
    }

}

