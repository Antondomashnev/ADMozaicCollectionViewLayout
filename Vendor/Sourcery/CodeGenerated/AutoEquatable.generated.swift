// Generated using Sourcery 0.5.9 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

// swiftlint:disable file_length
fileprivate func compareOptionals<T>(lhs: T?, rhs: T?, compare: (_ lhs: T, _ rhs: T) -> Bool) -> Bool {
    switch (lhs, rhs) {
    case let (lValue?, rValue?):
        return compare(lValue, rValue)
    case (nil, nil):
        return true
    default:
        return false
    }
}

fileprivate func compareArrays<T>(lhs: [T], rhs: [T], compare: (_ lhs: T, _ rhs: T) -> Bool) -> Bool {
    guard lhs.count == rhs.count else { return false }
    for (idx, lhsItem) in lhs.enumerated() {
        guard compare(lhsItem, rhs[idx]) else { return false }
    }

    return true
}

// MARK: - AutoEquatable for classes, protocols, structs
// MARK: - ADMozaikLayoutColumn AutoEquatable
extension ADMozaikLayoutColumn: Equatable {} 
public func == (lhs: ADMozaikLayoutColumn, rhs: ADMozaikLayoutColumn) -> Bool {
    guard lhs.width == rhs.width else { return false }
    return true
}
// MARK: - ADMozaikLayoutGeometryInfo AutoEquatable
extension ADMozaikLayoutGeometryInfo: Equatable {} 
public func == (lhs: ADMozaikLayoutGeometryInfo, rhs: ADMozaikLayoutGeometryInfo) -> Bool {
    guard lhs.columns == rhs.columns else { return false }
    guard lhs.rowHeight == rhs.rowHeight else { return false }
    return true
}
// MARK: - ADMozaikLayoutMatrixPositionCacheKey AutoEquatable
extension ADMozaikLayoutMatrixPositionCacheKey: Equatable {} 
internal func == (lhs: ADMozaikLayoutMatrixPositionCacheKey, rhs: ADMozaikLayoutMatrixPositionCacheKey) -> Bool {
    guard lhs.size == rhs.size else { return false }
    guard lhs.section == rhs.section else { return false }
    return true
}
// MARK: - ADMozaikLayoutPosition AutoEquatable
extension ADMozaikLayoutPosition: Equatable {} 
public func == (lhs: ADMozaikLayoutPosition, rhs: ADMozaikLayoutPosition) -> Bool {
    guard lhs.column == rhs.column else { return false }
    guard lhs.row == rhs.row else { return false }
    guard lhs.section == rhs.section else { return false }
    return true
}
// MARK: - ADMozaikLayoutSize AutoEquatable
extension ADMozaikLayoutSize: Equatable {} 
public func == (lhs: ADMozaikLayoutSize, rhs: ADMozaikLayoutSize) -> Bool {
    guard lhs.columns == rhs.columns else { return false }
    guard lhs.rows == rhs.rows else { return false }
    return true
}

// MARK: - AutoEquatable for Enums

// MARK: -
