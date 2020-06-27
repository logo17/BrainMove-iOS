//
//  Routine.swift
//  BrainMove
//
//  Created by Heriberto Ureña madrigal on 6/26/20.
//  Copyright © 2020 Heriberto Ureña Madrigal. All rights reserved.
//

import Foundation

struct Routine {
    var name: String
    var routineNumber: Int
    var blocks: Array<Block>
    
    init?(data: [String: Any]) {
        guard let name = data["name"] as? String,
            let routineNumber = data["routineNumber"] as? Int,
            let blocks = data["blocks"] as? Array<[String: Any]> else {
                return nil
        }
        
        var auxBlocks = Array<Block>()
        
        blocks.forEach {
            if let block = Block(data: $0) {
                auxBlocks.append(block)
            }
        }

        self.name = name
        self.routineNumber = routineNumber
        self.blocks = auxBlocks
    }
}
