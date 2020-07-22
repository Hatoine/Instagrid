//
//  Grid.swift
//  Instagrid
//
//  Created by antoineantoniol on 13/02/2019.
//  Copyright © 2019 Antoine Antoniol. All rights reserved.
//

import Foundation

//MARK: - grids enumeration
enum Grid {
    case pattern1
    case pattern2
    case pattern3
    
    var display: [Bool] {
        switch self {
        case .pattern1:
            return [false,true,false,false]
        case .pattern2:
            return [false,false,false,true]
        case .pattern3:
            return [false,false,false,false]
        }
    }
}
