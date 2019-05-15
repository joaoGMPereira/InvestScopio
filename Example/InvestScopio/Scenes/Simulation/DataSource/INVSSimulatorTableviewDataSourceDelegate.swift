//
//  INVSSimulatorTableviewDataSourceDelegate.swift
//  InvestScopio
//
//  Created by Joao Medeiros Pereira on 12/05/19.
//

import Foundation
import UIKit

class INVSSimulatorTableviewDataSourceDelegate: NSObject,UITableViewDataSource,UITableViewDelegate {
    var simulatedValues = [INVSSimulatedValueModel]()
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return simulatedValues.count
    }
    
    private func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "Cell")
        if (cell == nil) {
            cell = UITableViewCell(style:.default, reuseIdentifier:"Cell")
        }
        cell?.textLabel?.numberOfLines = 0
        cell?.textLabel?.text = "MES: \(simulatedValues[indexPath.row].month ?? 0), \nAPORTE DO MES: \(simulatedValues[indexPath.row].monthValue ?? 0), \nLUCRO DO MES: \(simulatedValues[indexPath.row].profitability ?? 0), \nRETIRADA: \(simulatedValues[indexPath.row].rescue ?? 0)\n, \nTOTAL: \(simulatedValues[indexPath.row].total ?? 0)\n"
        return cell ?? UITableViewCell()
    }
    

}
