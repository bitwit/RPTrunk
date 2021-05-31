//
//  StatusParser.swift
//  
//
//  Created by Kyle Newsome on 2021-05-31.
//

import Foundation
import Parsing

func getStatus(_ status: String) -> (ParserResultType) -> ParserResultType {
    {
        input in
        if case let .entityResult(e) = input {
            let found = e.hasStatus(status)
            return .valueResult(.bool(found))
        }
        return .nothing
    }
}

let statusParser =
    Skip(Prefix(while: { $0 == " " }))
    .take(Prefix(while: { $0 != " " }))
    .flatMap({ result -> AnyParser<Substring, ParserResultType> in
        guard result.last == "?" else {
            return Fail().eraseToAnyParser()
        }
        
        let status = String(result.dropLast())
        let function = getStatus(status)
        
        return Always(.evaluationFunction(f: function)).eraseToAnyParser()
    })
