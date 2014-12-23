//
//  UICollectionGridViewController.swift
//  UICollectionGridView
//
//  Created by anthony on 12/23/14.
//  Copyright (c) 2014 com.anthonyliao. All rights reserved.
//

import Foundation
import UIKit

protocol UICollectionGridViewSortDelegate {
    func sort(colIndex: Int, asc: Bool, rows: [[AnyObject]]) -> [[AnyObject]]
}

class UICollectionGridViewController: UICollectionViewController {
    var cols: [String]! = []
    
    var rows: [[AnyObject]]! = []
    
    var sortDelegate: UICollectionGridViewSortDelegate!
    
    //No columns are selected initially
    private var selectedColIdx = -1
    private var asc = true
    
    override init() {
        var layout = UICollectionGridViewLayout()
        super.init(collectionViewLayout: layout)
        layout.viewController = self
//        collectionView!.layer.borderWidth = 1
//        collectionView!.layer.borderColor = UIColor.redColor().CGColor
        collectionView!.backgroundColor = UIColor.whiteColor()
        collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView!.delegate = self
        collectionView!.dataSource = self
        collectionView!.directionalLockEnabled = true
        collectionView!.contentInset = UIEdgeInsetsMake(0, 10, 0, 10)
        collectionView!.bounces = false
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("UICollectionGridViewController.init(coder:) has not been implemented")
    }
    
    func setColumns(columns: [String]) {
        cols = columns
    }
    
    func addRow(row: [AnyObject]) {
        rows.append(row)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidLayoutSubviews() {
        collectionView!.frame = CGRectMake(0, 0, view.frame.width, view.frame.height)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        //Returns the number of rows in the grid
        if cols.isEmpty {
            return 0
        }
        //Also include the column when returning rows
        return rows.count + 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //Returns the number of columns in the grid
        return cols.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as UICollectionViewCell
        //        cell.layer.borderWidth = 1
        cell.backgroundColor = UIColor.whiteColor()
        cell.clipsToBounds = true
        for subview in cell.subviews {
            subview.removeFromSuperview()
        }
        
        var label = UILabel(frame: CGRectMake(0, 0, cell.frame.width, cell.frame.height))
        label.textAlignment = NSTextAlignment.Left
        if indexPath.row != 0 {
            label.textAlignment = NSTextAlignment.Center
        }
        if indexPath.section == 0 {
            var text = NSAttributedString(string: cols[indexPath.row], attributes: [
                NSUnderlineStyleAttributeName:NSUnderlineStyle.StyleSingle.rawValue,
                NSFontAttributeName:UIFont.boldSystemFontOfSize(15)
                ])
            label.attributedText = text
        } else {
            label.font = UIFont.systemFontOfSize(15)
            label.text = "\(rows[indexPath.section-1][indexPath.row])"
        }
        cell.addSubview(label)
        
        //Column highlighting and sorting
        if indexPath.row == selectedColIdx {
            cell.backgroundColor = UIColor(red: 220/255, green: 255/255, blue: 255/255, alpha: 1)
            if indexPath.section == 0 {
                var imageWidth: CGFloat = 15
                var imageHeight: CGFloat = 20
                var labelHeight = label.frame.height
                label.sizeToFit()
                label.frame = CGRectMake(0, 0, min(label.frame.width, cell.frame.width - imageWidth), labelHeight)
                var image = IonIcons.imageWithIcon(icon_ios7_arrow_thin_down, iconColor: UIColor.blackColor(), iconSize: 20, imageSize: CGSizeMake(imageWidth, imageHeight))
                if asc {
                    image = IonIcons.imageWithIcon(icon_ios7_arrow_thin_up, iconColor: UIColor.blackColor(), iconSize: 20, imageSize: CGSizeMake(imageWidth, imageHeight))
                }
                var imageView = UIImageView(image: image)
                cell.addSubview(imageView)
                imageView.frame = CGRectMake(label.frame.width, cell.frame.height/2 - imageView.frame.height/2, imageView.frame.width, imageView.frame.height)
            }
        }
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        println("Cell selected at: [\(indexPath.section),\(indexPath.row)]")
        if indexPath.section == 0 && sortDelegate != nil {
            //If it's a newly selected column, sort by asc. Else, toggle asc/desc
            asc = (selectedColIdx != indexPath.row) ? true : !asc
            selectedColIdx = indexPath.row
            rows = sortDelegate.sort(indexPath.row, asc: asc, rows: rows)
            collectionView.reloadData()
        }
    }
}