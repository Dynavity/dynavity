import Foundation

/**
 Unique ID for UmlElements. This ensures that UmlConnectors that uses ID connections can only connect between
 UmlElements.
 */
struct UmlElementId: Codable, Equatable {
    var id: Int
}
