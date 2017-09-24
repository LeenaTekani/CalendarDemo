//
//  ViewController.swift
//  CalendarDemo
//
//  Created by Apple on 31/07/17.
//  Copyright © 2017 leena. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var lblMonth: UILabel!
    var arrMonth:[Date]! = [Date]()
    @IBOutlet weak var clnView: UICollectionView!
    var dateFormatter = DateFormatter()
    var lastContentOffset :CGPoint!
    var currentIndex : Int = 0
    
    override func viewDidLoad(){
        super.viewDidLoad()
        self.doInitialSettings()
    }
    
    func doInitialSettings()
    {
        let date = Date()
        arrMonth.append(self.getCurrentMontDate(-1, date: date))
        arrMonth.append(self.getCurrentMontDate(0, date: date))
        arrMonth.append(self.getCurrentMontDate(1, date: date))
        
        self.clnView.reloadData()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
            self.clnView.scrollToItem(at:IndexPath(item: 1, section: 0), at: .right, animated: false)
            self.setMonthName(self.arrMonth[1])
        }
    }
    
    func setMonthName(_ date:Date)
    {
        dateFormatter.dateFormat = "MMMM - yyyy"
        lblMonth.text = dateFormatter.string(from: date)
    }
    
    func checkIfDateExists(_ date:Date) -> Bool {
        for aDate in arrMonth
        {
            if aDate == date {
                return true
            }
        }
        return false
    }
    
    func getCurrentMontDate(_ monthOffset:Int,date:Date) -> Date
    {
        let units: Set<Calendar.Component> = [ .day, .month, .year]
        var comps = Calendar.current.dateComponents(units, from: date)
        comps.month = comps.month! + monthOffset
        comps.day = 1
        let newDate = Calendar.current.date(from: comps)
        return newDate!
    }
    
    
}

extension ViewController : UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate
{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth = self.clnView.frame.size.width
        let currentPage : Int = Int(self.clnView.contentOffset.x / pageWidth)
        currentIndex = currentPage
    }
    
    
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        lastContentOffset = scrollView.contentOffset;
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if lastContentOffset.x > scrollView.contentOffset.x
        {
            print("scrollLeft:\(currentIndex)")
            let aDate = self.getCurrentMontDate(-1, date: self.arrMonth[currentIndex])
            if !self.checkIfDateExists(aDate) {
                arrMonth.insert(aDate, at: 0)
                self.clnView.reloadData()
                let aNextIndPath = IndexPath(item: 1, section: 0)
                self.clnView.scrollToItem(at:aNextIndPath , at: .left, animated: false)
            }
            
            self.setMonthName(self.arrMonth[currentIndex])

            
        }
        else if lastContentOffset.x < scrollView.contentOffset.x
        {
            print("scrollright:\(currentIndex)")
            let aDate = self.getCurrentMontDate(1, date: self.arrMonth[currentIndex])
            if !self.checkIfDateExists(aDate) {
                arrMonth.append(aDate)
               
            }
            self.clnView.reloadData()
            self.setMonthName(self.arrMonth[currentIndex])

        }
        

    }
   
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrMonth.count
    }
    

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let aCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MonthCell", for: indexPath) as! MonthClnViewCell
        aCell.currentDate = arrMonth[indexPath.row]
        aCell.getDateForMonth()
        aCell.clnViewMonth.reloadData()
        
        print("CurrentIndexPath:-\(indexPath)")
        
        return aCell

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let aScreenWidth = UIScreen.main.bounds.size.width
        return CGSize(width: aScreenWidth, height: collectionView.frame.size.height)
    }

}

