//
//  File.swift
//  Phantom
//
//  Created by Alberto Cantallops on 16/09/2017.
//  Copyright © 2017 Alberto Cantallops. All rights reserved.
//

import Foundation

enum Result<Value> {
    case success(Value)
    case failure(Error)

    var isSuccess: Bool {
        switch self {
        case .success:
            return true
        default:
            return false
        }
    }

    var value: Value? {
        switch self {
        case .success(let value): return value
        default: return nil
        }
    }

    var error: Error? {
        switch self {
        case .failure(let error): return error
        default: return nil
        }
    }

    var isFailure: Bool {
        return !isSuccess
    }
}

extension Result {
    public init(_ capture: () throws -> Value) {
        do {
            self = .success(try capture())
        } catch {
            self = .failure(error)
        }
    }
}

extension Result {
    func combined<T>(result: Result<T>) -> Result<(Value, T)> {
        switch (self, result) {
        case (.success(let selfValue), .success(let resultValue)):
            return .success((selfValue, resultValue))
        case (.success, .failure(let error)):
            return .failure(error)
        case (.failure(let error), .success):
            return .failure(error)
        case (.failure(let selfError), .failure(let resultError)):
            return .failure(CombinedError(errors: [selfError, resultError]))
        }
    }
}

struct CombinedError: Error {
    let errors: [Error]
}

extension CombinedError: LocalizedError {
    public var errorDescription: String? {
        let descriptions: [String] = errors.compactMap({ $0.localizedDescription })
        let set = Set(descriptions)
        let array = Array(set)
        return array.joined(separator: "\n")
    }
}

struct NotImplementedError: Error {

}
