import SwiftUI

struct ShareMenuView: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIActivityViewController

    var itemsToShare: [Any]
    var servicesToShareItem: [UIActivity]?

    func makeUIViewController(context: Context) -> UIViewControllerType {
        let activityViewController = UIViewControllerType(activityItems: itemsToShare,
                                                          applicationActivities: servicesToShareItem)
        activityViewController.isModalInPresentation = true
        return activityViewController
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        // Do nothing.
    }
}
