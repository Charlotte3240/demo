//
//  ViewController.swift
//  CollectionViewLongPressDrag
//
//  Created by 刘春奇 on 2016/11/24.
//  Copyright © 2016年 刘春奇. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource{

    @IBOutlet weak var collectionView: UICollectionView!
    private var dataList = [CellModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fillData()
        let layout = Layout.init()
        self.collectionView.collectionViewLayout = layout
        self.collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "CollectionViewCell")
    }



    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return self.dataList.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell : CollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell

        cell.backgroundColor = UIColor.orange
        return cell
        
    }

    func fillData() -> Void {
        for i in 0..<30{
            let model  = CellModel()
            model.title = String(i)
            self.dataList.append(model)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

