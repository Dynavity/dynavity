protocol BacklinkGraph {
    mutating func addLinkBetween(_ firstItem: AnyNamedIdentifiable, and secondItem: AnyNamedIdentifiable)
    func getBacklinks(for item: AnyNamedIdentifiable) -> [AnyNamedIdentifiable]
}
