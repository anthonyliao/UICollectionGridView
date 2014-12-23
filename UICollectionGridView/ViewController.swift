//
//  ViewController.swift
//  UICollectionGridView
//
//  Created by anthony on 12/23/14.
//  Copyright (c) 2014 com.anthonyliao. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionGridViewSortDelegate {
    
    var gridViewController: UICollectionGridViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        gridViewController = UICollectionGridViewController()
        gridViewController.setColumns(["Contact", "Sent", "Received", "Open Rate"])
        gridViewController.addRow(["john smith", "100", "88", "10%"])
        gridViewController.addRow(["john doe", "23", "16", "81%"])
        gridViewController.addRow(["derrick favors", "43", "65", "93%"])
        gridViewController.addRow(["jared black", "75", "2", "43%"])
        gridViewController.addRow(["james olmos", "43", "12", "33%"])
        gridViewController.addRow(["thomas frank", "13", "87", "45%"])
        gridViewController.addRow(["laura james", "33", "22", "15%"])
        gridViewController.sortDelegate = self
        view.addSubview(gridViewController.view)
    }
    
    override func viewDidLayoutSubviews() {
        gridViewController.view.frame = CGRectMake(0, 50, view.frame.width, view.frame.height-60)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func sort(colIndex: Int, asc: Bool, rows: [[AnyObject]]) -> [[AnyObject]] {
        var sortedRows = rows.sorted { (firstRow: [AnyObject], secondRow: [AnyObject]) -> Bool in
            var firstRowValue = firstRow[colIndex] as String
            var secondRowValue = secondRow[colIndex] as String
            if colIndex == 0 {
                //If name column, compare lexographically
                if asc {
                    return firstRowValue < secondRowValue
                }
                return firstRowValue > secondRowValue
            } else if colIndex == 1 || colIndex == 2 {
                //Else Received/Sent column, compare as integers
                if asc {
                    return firstRowValue.toInt()! < secondRowValue.toInt()!
                }
                return firstRowValue.toInt()! > secondRowValue.toInt()!
            }
            //Last column is percent, strip off the % character then compare as integers
            var firstRowValuePercent = firstRowValue.substringWithRange(Range(start: firstRowValue.startIndex, end: advance(firstRowValue.endIndex, -1))).toInt()!
            var secondRowValuePercent = secondRowValue.substringWithRange(Range(start: secondRowValue.startIndex, end: advance(secondRowValue.endIndex, -1))).toInt()!
            if asc {
                return firstRowValuePercent < secondRowValuePercent
            }
            return firstRowValuePercent > secondRowValuePercent
        }
        return sortedRows
    }

}

