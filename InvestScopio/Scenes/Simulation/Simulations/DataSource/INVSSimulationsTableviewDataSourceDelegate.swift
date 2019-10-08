//
//  INVSSimulatorTableviewDataSourceDelegate.swift
//  InvestScopio
//
//  Created by Joao Medeiros Pereira on 12/05/19.
//

import Foundation
import UIKit
import SkeletonView
typealias DidFinishDeleteSimulation = ((_ success: Bool) -> ())
protocol INVSSimulationsTableviewDataSourceDelegateProtocol {
    func didSelect(withSimulation simulation: INVSSimulatorModel)
    func didDelete(withSimulation simulation: INVSSimulatorModel, completion: @escaping(DidFinishDeleteSimulation))
    func removeAllSimulations()
}

class INVSSimulationsTableviewDataSourceDelegate: NSObject,SkeletonTableViewDataSource,UITableViewDelegate {
    let countSampleCells = 4
    private var simulations = [INVSSimulatorModel]()
    fileprivate var indexPaths: Set<IndexPath> = []
    var delegate: INVSSimulationsTableviewDataSourceDelegateProtocol?
    
    func setup(withSimulations simulations: [INVSSimulatorModel]) {
        self.simulations = simulations
    }
    
    func expandCell(tableView: UITableView, indexPath: IndexPath) {
        tableView.beginUpdates()
            if let cell = tableView.cellForRow(at: indexPath) as? INVSSimulationCell {
                if simulations.count > 0 {
                    let simulation = simulations[indexPath.row]
                    if let isSimply = simulation.isSimply {
                        if isSimply {
                            cell.state = .static
                        } else {
                            if shouldAddIndexPath(indexPath) == true {
                                cell.state = .expanded
                            } else {
                                cell.state = .collapsed
                            }
                        }
                    }
                    cell.toggle(withNeedsLayout: false)
                }
            }
        tableView.endUpdates()
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return ReusableCellIdentifier(INVSConstants.SimulatorCellConstants.cellIdentifier.rawValue)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return simulations.count != 0 ? simulations.count : countSampleCells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell:INVSSimulationCell? = tableView.dequeueReusableCell(withIdentifier: INVSConstants.SimulationCellConstants.cellIdentifier.rawValue) as? INVSSimulationCell
        if (cell == nil) {
            cell = INVSSimulationCell(style:.default, reuseIdentifier:INVSConstants.SimulationCellConstants.cellIdentifier.rawValue)
        }
        cell?.contentView.layoutIfNeeded()
        cell?.selectionStyle = .none
        if simulations.count > 0 {
            let simulation = simulations[indexPath.row]
            cell?.setup(withSimulation: simulation, indexPath: indexPath)
            cell?.expandCellAction = { (button, indexPath) in
                self.expandCell(tableView: tableView, indexPath: indexPath)
            }
            if let isSimply = simulation.isSimply {
                if isSimply {
                    cell?.state = .static
                } else {
                    cell?.state = cellIsExpanded(at: indexPath) ? .expanded : .collapsed
                }
            }
        } else {
            cell?.setupSkeletonView()
        }
        cell?.toggle()
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if simulations.count > 0 {
            let simulation = simulations[indexPath.row]
            self.delegate?.didSelect(withSimulation: simulation)
        }
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Apagar"
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return simulations.count > 0
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if simulations.count > 0 {
            if editingStyle == .delete {
                
                tableView.beginUpdates()
                if let cell = tableView.cellForRow(at: indexPath) as? INVSSimulationCell {
                    cell.setupSkeletonView()
                }
                tableView.endUpdates()
                
                let simulation = simulations[indexPath.row]
                delegate?.didDelete(withSimulation: simulation, completion: { (success) in
                    if success {
                        self.simulations.remove(at: indexPath.row)
                        if self.simulations.count != 0 {
                            tableView.deleteRows(at: [indexPath], with: .bottom)
                        } else {
                           self.delegate?.removeAllSimulations()
                        }
                            
                    }
                })
            }
        }
    }
}

extension INVSSimulationsTableviewDataSourceDelegate {
    
    func hasRescue(simulation: INVSSimulatorModel) -> Bool {
       return (simulation.initialMonthlyRescue != 0 || simulation.increaseRescue != 0 || simulation.goalIncreaseRescue != 0)
    }
    func cellIsExpanded(at indexPath: IndexPath) -> Bool {
        return indexPaths.contains(indexPath)
    }
    
    func shouldAddIndexPath(_ indexPath: IndexPath) -> Bool {
        if indexPaths.contains(indexPath) {
            removeExpandedIndexPath(indexPath)
            return false
        }
        indexPaths.insert(indexPath)
        return true
    }
    
    func removeExpandedIndexPath(_ indexPath: IndexPath) {
        indexPaths.remove(indexPath)
    }
}

extension INVSSimulationsTableviewDataSourceDelegate {
    subscript(indexPath: IndexPath) -> INVSSimulatorModel {
        return simulations[indexPath.row]
    }
}
