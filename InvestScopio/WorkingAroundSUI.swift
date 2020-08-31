//
//  WorkingAroundSUI.swift
//  InvestScopio
//
//  Created by Joao Gabriel Pereira on 16/08/20.
//  Copyright © 2020 Joao Medeiros Pereira. All rights reserved.
//

import UIKit

struct WorkingAroundSUI {
    
    static func setupWorkingArounds() {
        tableViewWorkingAround()
        tabbarWorkingAround()
    }
    static func tableViewWorkingAround() {
        UITableView.appearance().tableFooterView = UIView()
        UITableViewCell.appearance().backgroundColor = .clear
        UITableView.appearance().backgroundColor = .clear
        UITableView.appearance().separatorStyle = .none
        UITableViewCell.appearance().selectionStyle = .none
    }
    
    static func tabbarWorkingAround() {
        UITabBar.appearance().layer.borderWidth = 0.0
        UITabBar.appearance().clipsToBounds = true
    }
}
