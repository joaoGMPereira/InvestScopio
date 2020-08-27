import SwiftUI

struct ExampleView: View {
    @State var text: String = ""
    
    var body: some View {
        UIKitTabView {
            NavView().tab(title: "First", badgeValue: "3")
            Text("Second View").tab(title: "Second")
        }
    }
}

struct NavView: View {
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: Text("This page stays when you switch back and forth between tabs (as expected on iOS)")) {
                    Text("Go to detail")
                }
            }
        }
    }
}


struct ExampleView_Previews: PreviewProvider {
    static var previews: some View {
        ExampleView()
    }
}
