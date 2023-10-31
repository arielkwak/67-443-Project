import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: Int = 0  // To keep track of the currently selected tab

    init() {
      let appearance = UITabBarAppearance()
      appearance.backgroundColor = .black
      UITabBar.appearance().scrollEdgeAppearance = appearance
      UITabBar.appearance().standardAppearance = appearance
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            // Chords Tab
            ChordsView(viewController: ChordsViewController())
                .tabItem {
                    Image(selectedTab == 0 ? "chords_tab_grey" : "chords_tab_highlighted")
                    Text("Chords")
                }
                .tag(0)
            
            // Home Tab
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
            
            // Songs Tab
            SongsView()
                .tabItem {
                    Image(systemName: "music.mic")
                    Text("Songs")
                }
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
