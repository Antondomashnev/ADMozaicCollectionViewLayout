//
//  ADMozaikLayoutEnums.swift
//  ADMozaikCollectionViewLayout
//
//  Created by Anton Domashnev on 7/17/18.
//  Copyright © 2018 Anton Domashnev. All rights reserved.
//

import Foundation

/**
 *  Defines the layout's content mode
 */
public enum ADMozaikLayoutSectionContentMode: AutoEquatable {
    /**
     * Try to fill all vacant spaces for the cell
     * Default value
     */
    case fill
    
    /**
     * Keep the order for cells, so even if there is a vacant space somewhere before last cell don't use it
     */
    case ordered
}
