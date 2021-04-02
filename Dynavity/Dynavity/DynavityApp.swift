import SwiftUI
import Firebase

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        return true
     }
}

@main
struct DynavityApp: App {
    @StateObject var graphMapViewModel = GraphMapViewModel()

    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(graphMapViewModel)
        }
    }
}
