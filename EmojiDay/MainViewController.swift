//
//  MainViewController.swift
//  EmojiDay
//
//  Created by Michael Pace on 2/13/16.
//  Copyright © 2016 Michael Pace. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    // MARK: - Properties

    static let sharedInstance = MainViewController()

    // MARK: - Initialization

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    init() {
        super.init(nibName: nil, bundle: nil)
        setup()
    }

    func setup() {
        let entryListViewController = EntryListViewController()
        entryListViewController.tabBarItem = UITabBarItem(title: "EmojiDay", image: nil, tag: 1)
        viewControllers = [entryListViewController]
    }

}
