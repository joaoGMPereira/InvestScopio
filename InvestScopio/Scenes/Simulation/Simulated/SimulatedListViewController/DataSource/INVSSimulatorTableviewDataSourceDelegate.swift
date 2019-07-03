//
//  INVSSimulatorTableviewDataSourceDelegate.swift
//  InvestScopio
//
//  Created by Joao Medeiros Pereira on 12/05/19.
//

import Foundation
import UIKit
import SkeletonView

class INVSSimulatorTableviewDataSourceDelegate: NSObject,SkeletonTableViewDataSource,UITableViewDelegate {
    let countSampleCells = 4
    private var simulatedValues = [INVSSimulatedValueModel]()
    private var headerSimulatedValue = INVSSimulatedValueModel()
    private var simulatorHeaderView: INVSSimulatorHeaderView!
    
    func setup(withSimulatedValues simulatedValues: [INVSSimulatedValueModel]) {
        if let firstAplication = simulatedValues.first {
            self.headerSimulatedValue = firstAplication
        }
        self.simulatedValues = simulatedValues.filter({$0.month != nil})
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return ReusableCellIdentifier(INVSConstants.SimulatorCellConstants.cellIdentifier.rawValue)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        simulatorHeaderView = INVSSimulatorHeaderView(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 100))
        if simulatedValues.count > 0 {
            simulatorHeaderView.setup(withSimulatedValue: headerSimulatedValue)
        }
        return simulatorHeaderView
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return simulatedValues.count != 0 ? simulatedValues.count : countSampleCells
    }
    
    private func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:INVSSimulatorCell? = tableView.dequeueReusableCell(withIdentifier: INVSConstants.SimulatorCellConstants.cellIdentifier.rawValue) as? INVSSimulatorCell
        if (cell == nil) {
            cell = INVSSimulatorCell(style:.default, reuseIdentifier:INVSConstants.SimulatorCellConstants.cellIdentifier.rawValue)
        }
        let _ = cell?.separatorsView.compactMap({ (view) -> UIView? in
            view.backgroundColor = .INVSDefault()
            return view
        })
        cell?.contentView.layoutIfNeeded()
        if simulatedValues.count > 0 {
            cell?.setup(withSimulatedValue: simulatedValues[indexPath.row])
            print("MES: \(simulatedValues[indexPath.row].month ?? 0), \nAPORTE DO MES: \(simulatedValues[indexPath.row].monthValue ?? 0), \nLUCRO DO MES: \(simulatedValues[indexPath.row].profitability ?? 0), \nRETIRADA: \(simulatedValues[indexPath.row].rescue ?? 0)\n, \nTOTAL: \(simulatedValues[indexPath.row].total ?? 0)\n")
        }
        return cell ?? UITableViewCell()
    }
    

}
