import SwiftUI

struct ChordsView: View {
  @ObservedObject var viewController: ChordsViewController
  
  var body: some View {
    NavigationView {
      ScrollView {
        VStack(spacing: 10) {
          Text("CHORDS")
            .font(.largeTitle)
            .foregroundColor(.white)
            .padding()
          
          HStack {
            Button(action: {
              viewController.filterOnCompleted = true
            }) {
              Text("Completed")
                .padding()
                .background(viewController.filterOnCompleted ? Color.blue : Color.gray)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
            
            Button(action: {
              viewController.filterOnCompleted = false
            }) {
              Text("Incomplete")
                .padding()
                .background(viewController.filterOnCompleted ? Color.gray : Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
          }.padding([.leading, .trailing])
          
          ForEach(["easy", "medium", "hard"], id: \.self) { difficulty in
            VStack {
              Text(difficulty.capitalized)
                .font(.title2)
                .padding(.top)
                .foregroundColor(.white)
              
              LazyVGrid(columns: Array(repeating: GridItem(.fixed(114), spacing: 10), count: 3), spacing: 10) {
                ForEach(viewController.displayedChords.filter { $0.difficulty == difficulty }, id: \.self) { chord in
                  let displayableName = chord.displayableName.replacingOccurrences(of: "m", with: "")
                  let chordParts = displayableName.components(separatedBy: "#")
                  NavigationLink(destination: ChordDetailView(chord: chord)) {
                    VStack {
                      HStack {
                        if let firstPart = chordParts.first {
                          Text(firstPart)
                            .font(.custom("Barlow-BlackItalic", size: 64))
                            .foregroundColor(.white)
                            .fixedSize(horizontal: false, vertical: true)
                        }
                        if chordParts.count > 1 {
                          Text("#" + chordParts[1])
                            .font(.custom("Barlow-BlackItalic", size: 32))
                            .foregroundColor(.white)
                            .fixedSize(horizontal: false, vertical: true)
                            .offset(x:-5, y: -10)
                        }
                      }.frame(width:90)
                      Text(chord.quality ?? "Major or Minor")
                        .font(.custom("Barlow-Regular", size: 24))
                        .foregroundColor(.white)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.bottom, 10)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 10)
                    .background(Color.black)
                    .cornerRadius(15)
                    //                    .onTapGesture {
                    //                      viewController.completeChord(chord)
                    //                    }
                  }
                }
              }
            }
          }
        }
      }
      .background(Color(red: 35 / 255.0, green: 35 / 255.0, blue: 35 / 255.0))
    }
  }
}
