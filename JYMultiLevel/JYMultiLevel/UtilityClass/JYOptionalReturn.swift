//
//  JYOptionalReturn.swift
//  JYMultiLevel
//
//  Created by weijingyun on 16/11/26.
//  Copyright © 2016年 weijingyun. All rights reserved.
//

import Foundation

public struct NilError: Error, CustomStringConvertible {
    public var description: String { return _description }
    public init(error:String, file: String, line: Int) {
        
        _description = error
        #if DEBUG
            _description = _description + "  DEBUG --- Nil returned at "
                + (file as NSString).lastPathComponent + ":\(line)"
        #endif
        
    }
    private var _description: String
}

extension Optional {
    public func unwrap(_ error:String = "", file: String = #file, line: Int = #line) throws -> Wrapped {
        guard let unwrapped = self else { throw NilError(error:error, file: file, line: line) }
        return unwrapped
    }
}

