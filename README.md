UICollectionGridView
====================

an iOS multi-column sortable table control

![](/UICollectionGridView/blob/master/UICollectionGridViewDemo.gif)

How to use
----------
Create the controller, set the columns, and add rows
<pre><code>
gridViewController = UICollectionGridViewController()
gridViewController.setColumns(["Contact", "Sent", "Received", "Open Rate"])
gridViewController.addRow(["john smith", "100", "88", "10%"])
gridViewController.addRow(["john doe", "23", "16", "81%"])
gridViewController.addRow(["derrick favors", "43", "65", "93%"])
...
view.addSubview(gridViewController.view)
</code></pre>

Add logic to sort the columns
<pre><code>
func sort(colIndex: Int, asc: Bool, rows: [[AnyObject]]) -> [[AnyObject]] {
    var sortedRows = rows.sorted { (firstRow: [AnyObject], secondRow: [AnyObject]) -> Bool in
        //sort logic
    }
    return sortedRows
}
</code></pre>

How to install
--------------
1. Install `ionicons-IOS` - https://github.com/sweetmandm/ionicons-iOS
2. Import and create `UICollectionGridViewController`

Demo
----
1. Clone project
2. Run `pod install`
3. Open `UICollectionGridView.xcworkspace`

