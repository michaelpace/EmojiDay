//
//  EntryListViewController.swift
//  EmojiDay
//
//  Created by Michael Pace on 12/28/15.
//  Copyright © 2015 Michael Pace. All rights reserved.
//

import Foundation
import CoreData

class EntryListViewController: UITableViewController {
    
    // MARK: - Properties
    
    var dataSource: DataSource!
    var currentEntry: Entry {
        let entry = dataSource.fetchedObjects.first as? Entry ?? Entry.makeTodayEntry()

        if let date = entry.date {
            return date.isToday() ? entry : Entry.makeTodayEntry()
        } else {
            // execution shouldn't ever enter this block.
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
        
        setupDataSource()
        setupTableView()
        setupGestureRecognizer()
    }
}

// MARK: - UITableViewDataSource

extension EntryListViewController {
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.fetchedObjects.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        let entry = entryForIndexPath(indexPath)
        
        if entry.isTodayEntry() {
            guard let todayCell = tableView.dequeueReusableCellWithIdentifier(EntryTodayTableViewCell.nibIdentifier,
                forIndexPath: indexPath) as? EntryTodayTableViewCell else {
                    fatalError("Error dequeueing EntryTodayTableViewCell")
            }
            
            todayCell.entry = entry
            currentEntryCell = todayCell
            
            cell = todayCell
        } else {
            guard let entryCell = tableView.dequeueReusableCellWithIdentifier(EntryTableViewCell.nibIdentifier,
                forIndexPath: indexPath) as? EntryTableViewCell else {
                    fatalError("Error dequeueing EntryTableViewCell")
            }
            
            entryCell.entry = entry
            cell = entryCell
        }

        return cell
    }
}

// MARK: - UITableViewDelegate

extension EntryListViewController {
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let entry = entryForIndexPath(indexPath)

        if entry.isTodayEntry() {
            let maximumLineWidth = EntryTodayTableViewCell.widthOfEntryComposerGivenTableView(tableView)
            return entry.heightGivenMaximumLineWidth(maximumLineWidth) + EntryTodayTableViewCell.heightOfCellWithNoContent
        } else {
            return UITableViewAutomaticDimension
        }
    }
}

// MARK: - DataSourceDelegate

extension EntryListViewController: DataSourceDelegate {
    func contentDidChange() {
        tableView.reloadData()
    }
}

// MARK: - SentenceChooserDelegate

extension EntryListViewController: SentenceChooserDelegate {
    func sentenceChosen(sentence: String) {
        currentEntry.addSentenceWithPrefix(sentence, emoji: nil)
        currentEntryCell?.selectLastSentence()
    }
}

// MARK: - Private implementation

extension EntryListViewController {
    private func entryForIndexPath(indexPath: NSIndexPath) -> Entry {
        guard let entry = dataSource.fetchedObjects[indexPath.row] as? Entry else {
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
        tableView.estimatedRowHeight = 50
    }
    
    private func setupDataSource() {
        let fetchRequest = Entry.sortedFetchRequest
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.fetchBatchSize = 20
        dataSource = DataSource(fetchRequest: fetchRequest, managedObjectContext: DataManager.sharedInstance.managedObjectContext, delegate: self)
    }

    private func setupGestureRecognizer() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: "tapReceived:")
        gestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(gestureRecognizer)
    }

    @objc private func tapReceived(gestureRecognizer: UITapGestureRecognizer) {
        guard let currentEntryCell = currentEntryCell where !currentEntryCell.frame.contains(gestureRecognizer.locationInView(view)) else {
            return
        }

        currentEntryCell.hideKeyboard()
    }
}
