//
//  EntryListViewController.swift
//  EmojiDay
//
//  Created by Michael Pace on 12/28/15.
//  Copyright © 2015 Michael Pace. All rights reserved.
//

import Foundation
import CoreData

class EntryListViewController: UITableViewController, DataManagerDelegate, SentenceChooserDelegate {
    
    // MARK: Properties
    
    var dataManager: DataManager?
    var currentEntry: Entry {
        var entry: Entry? = dataManager?.fetchedObjects.first as? Entry
        
        if (entry == nil) {
            entry = Entry.makeTodayEntry()
        }
        
        if (DateHelpers.dateIsToday(entry!.date!)) {
            return entry!
        } else {
            // we don't have an entry for today yet. make one.
            return Entry.makeTodayEntry()
        }
    }
    
    var currentDraftExists: Bool {
        return currentEntry.sentences?.count > 0
    }

    // MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupFetchedResultsController()
    }
    
    // MARK: UITableViewDataSource
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        guard let _ = dataManager?.fetchedObjects.count else {
            return 0
        }
        
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = dataManager?.fetchedObjects.count else {
            return 0
        }
        
        return count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(EntryTableViewCell.nibIdentifier, forIndexPath: indexPath) as! EntryTableViewCell
        
        guard let entry: Entry = dataManager?.fetchedObjects[indexPath.row] as? Entry else {
            fatalError(":(")
        }
        
        cell.entry = entry
        cell.liveEntry = indexPath.row == 0

        return cell
    }
    
    // MARK: UITableViewDelegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {}
    
    // MARK: DataManagerDelegate
    
    func contentDidChange() {
        tableView.reloadData()
    }
    
    // MARK: SentenceChooserDelegate
    
    func sentenceChosen(sentence: String) {
        currentEntry.addSentenceWithPrefix(sentence, emoji: nil)
        try! DataHelpers.sharedInstance.managedObjectContext.save()
    }
    
    // MARK: ()
    
    private func setupTableView() {
        tableView.registerNib(UINib(nibName: EntryTableViewCell.nibIdentifier, bundle: nil), forCellReuseIdentifier: EntryTableViewCell.nibIdentifier)
        let sentenceChooser: SentenceChooser = NSBundle.mainBundle().loadNibNamed("SentenceChooser", owner: self, options: nil)[0] as! SentenceChooser
        sentenceChooser.delegate = self
        sentenceChooser.frame = CGRectMake(0, 0, view.bounds.width, 64)
        tableView.allowsSelection = false
        tableView.tableHeaderView = sentenceChooser
        tableView.tableFooterView = UIView(frame: CGRectZero)
    }
    
    private func setupFetchedResultsController() {
        let fetchRequest = Entry.sortedFetchRequest
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.fetchBatchSize = 20
        dataManager = DataManager(fetchRequest: fetchRequest, managedObjectContext: DataHelpers.sharedInstance.managedObjectContext, delegate: self)
    }
}