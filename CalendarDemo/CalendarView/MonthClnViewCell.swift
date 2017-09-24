//
//  MonthClnViewCell.swift
//  CalendarDemo
//
//  Created by Apple on 05/08/17.
//  Copyright © 2017 leena. All rights reserved.
//

import UIKit

class MonthClnViewCell: UICollectionViewCell {
    
    @IBOutlet weak var clnViewMonth: UICollectionView!
    var currentDate:Date!
    
    var arrDate:[Date]! = [Date]()
    var arrDateStr:[Int]! = [Int]()

   
    func getDateForMonth()  {
        arrDateStr.removeAll()
        let calendar = Calendar.current
        
        let range = calendar.range(of: .day, in: .month, for: currentDate)!
        let totalDays = range.count
        
        let weekday = calendar.component(.weekday, from: currentDate) - 1
        for i in 1...49
        {
            if i >= weekday && i <= (totalDays + weekday)
            {
                arrDateStr.append(i - weekday)
                
            }
            else
            {
                arrDateStr.append(0)
            }
        }
        clnViewMonth.reloadData()
    }
    
}

extension MonthClnViewCell : UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrDateStr.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let aCell = collectionView.dequeueReusableCell(withReuseIdentifier: "DateCell", for: indexPath) as! DateClnViewCell
        
        aCell.lbDate.text = self.arrDateStr[indexPath.row] == 0 ? "":"\(self.arrDateStr[indexPath.row])"
        
        return aCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let aScreenWidth = UIScreen.main.bounds.size.width/7
        return CGSize(width: aScreenWidth, height:50)
    }
}
