//
//  ViewController.swift
//  Rotule
//
//  Created by Mihir Singh on 4/24/15.
//  Copyright (c) 2015 citruspi. All rights reserved.
//

import UIKit
import HealthKit

class ViewController: UIViewController {

    let healthKitStore:HKHealthStore = HKHealthStore()

    override func viewDidLoad() {
        super.viewDidLoad()

        let healthKitTypesToRead = Set([
            HKObjectType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeartRate)
        ])

        healthKitStore.requestAuthorizationToShareTypes(nil, readTypes: healthKitTypesToRead, completion: nil)

        let endDate = NSDate()
        let startDate = NSCalendar.currentCalendar().dateByAddingUnit(.CalendarUnitDay,
            value: -1, toDate: endDate, options: nil)

        let heartRateSampleType = HKSampleType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeartRate)
        let predicate = HKQuery.predicateForSamplesWithStartDate(startDate,
            endDate: endDate, options: .None)

        let query = HKSampleQuery(sampleType: heartRateSampleType, predicate: predicate,
            limit: 0, sortDescriptors: nil, resultsHandler: {
                (query, results, error) in
                if error != nil {
                    println("There was an error running the query: \(error)")
                }
                dispatch_async(dispatch_get_main_queue()) {
                    for result in results {
                        println(result.quantity?.doubleValueForUnit(HKUnit(fromString: "count/min")))
                    }
                }
        })

        healthKitStore.executeQuery(query)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

