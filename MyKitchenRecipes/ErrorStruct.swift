//
//  ErrorStruct.swift
//  MyKitchenRecipes
//
//  Created by Justin Liu on 12/15/19.
//  Copyright © 2019 Justin Liu. All rights reserved.
//

import Foundation

struct MyError: Error {
    let msg: String
    
    var localizedDescription: String {
        return NSLocalizedString(msg, comment: "")
    }
}

extension MyError: LocalizedError {
    public var errorDescription: String? {
            return NSLocalizedString(msg, comment: "")
    }
}
