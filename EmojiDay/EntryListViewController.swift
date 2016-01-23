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
    
    // MARK: - Properties
    
    var dataManager: DataManager!
    var currentEntry: Entry {
        var entry: Entry? = dataManager.fetchedObjects.first as? Entry
        
        if entry == nil {
            entry = Entry.makeTodayEntry()
        }
        
        if NSDate.dateIsToday(entry!.date!) {
            return entry!
        } else {
            // we don't have an entry for today yet. make one.
            return Entry.makeTodayEntry()
        }
    }
    var currentEntryCell: EntryTodayTableViewCell?
    
    var currentDraftExists: Bool {
        return currentEntry.sentences?.count > 0
    }

    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDataManager()
        setupTableView()
    }

    // MARK: - UITableViewDataSource
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataManager.fetchedObjects.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        
        if indexPath.row == 0 {
            let todayCell = tableView.dequeueReusableCellWithIdentifier(EntryTodayTableViewCell.nibIdentifier, forIndexPath: indexPath) as! EntryTodayTableViewCell
            
            todayCell.entry = entryForIndexPath(indexPath)
            todayCell.liveEntry = indexPath.row == 0
            currentEntryCell = todayCell
            
            cell = todayCell
        } else {
            let entryCell = tableView.dequeueReusableCellWithIdentifier(EntryTableViewCell.nibIdentifier, forIndexPath: indexPath) as! EntryTableViewCell
            
            entryCell.entry = entryForIndexPath(indexPath)
            
            cell = entryCell
        }

        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let entry = entryForIndexPath(indexPath)
        let maximumLineWidth = EntryTodayTableViewCell.widthOfEntryComposerGivenTableView(tableView)
        return entry.heightGivenMaximumLineWidth(maximumLineWidth) + EntryTodayTableViewCell.heightOfCellWithNoContent
    }
    
    // MARK: - DataManagerDelegate
    
    func contentDidChange() {
        tableView.reloadData()
    }
    
    // MARK: - SentenceChooserDelegate
    
    func sentenceChosen(sentence: String) {
        currentEntry.addSentenceWithPrefix(sentence, emoji: nil)
    }
    
    // MARK: - Private implementation
    
    private func entryForIndexPath(indexPath: NSIndexPath) -> Entry {
        guard let entry = dataManager.fetchedObjects[indexPath.row] as? Entry else {
            fatalError(":(")
        }
        
        return entry
    }
    
    private func setupTableView() {
        tableView.registerNib(UINib(nibName: EntryTodayTableViewCell.nibIdentifier, bundle: nil), forCellReuseIdentifier: EntryTodayTableViewCell.nibIdentifier)
        tableView.registerNib(UINib(nibName: EntryTableViewCell.nibIdentifier, bundle: nil), forCellReuseIdentifier: EntryTableViewCell.nibIdentifier)
        let sentenceChooser = SentenceChooser()
        sentenceChooser.delegate = self
        sentenceChooser.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 64)
        tableView.allowsSelection = false
        tableView.tableHeaderView = sentenceChooser
        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    private func setupDataManager() {
        let fetchRequest = Entry.sortedFetchRequest
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.fetchBatchSize = 20
        dataManager = DataManager(fetchRequest: fetchRequest, managedObjectContext: DataHelpers.sharedInstance.managedObjectContext, delegate: self)
    }
}
