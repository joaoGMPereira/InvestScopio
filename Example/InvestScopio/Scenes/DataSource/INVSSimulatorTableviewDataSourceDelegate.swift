//
//  INVSSimulatorTableviewDataSourceDelegate.swift
//  InvestScopio
//
//  Created by Joao Medeiros Pereira on 12/05/19.
//

import Foundation
import UIKit

class INVSSimulatorTableviewDataSourceDelegate: NSObject,UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    

}
