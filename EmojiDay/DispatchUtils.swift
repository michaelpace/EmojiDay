//
//  DispatchUtils.swift
//  EmojiDay
//
//  Created by Michael Pace on 2/21/16.
//  Copyright © 2016 Michael Pace. All rights reserved.
//

// MARK: - Public API

func dispatchToGlobalQueueSync(sync: Bool, qualityOfServiceClass: qos_class_t, block: () -> Void) {
    if sync {
        dispatch_sync(dispatch_get_global_queue(qualityOfServiceClass, 0), block)
    } else {
        dispatch_async(dispatch_get_global_queue(qualityOfServiceClass, 0), block)
    }
}
