protocol NavigationCoordinator {
    func push(_ path: any Routable)
    func popLast()
    func popToRoot()
}
