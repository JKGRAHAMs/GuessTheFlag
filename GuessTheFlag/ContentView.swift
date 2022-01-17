//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Joey Graham on 12/24/21.
//

import SwiftUI


struct ContentView: View {
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var totalScore = 0
    @State private var question = 1
    @State private var gameOver = false
    @State private var userTapped = 0
    @State private var offset = CGFloat.zero
    @State private var disabled = false
    @State private var opacity = 1.0
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "The United Kingdom", "The United States"].shuffled()
    @State private var correctAnswer  = Int.random(in: 0...2)
    
    @State private var cardSpinAmount = 0.0
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3),
            ], center: .top, startRadius: 200, endRadius: 700)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Text("Guess the Flag")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            if number == correctAnswer {
                                flagTapped(number)
                                userTapped = number
                                withAnimation(.interpolatingSpring(stiffness: 5, damping: 100)) {
                                    cardSpinAmount += 360
                                    opacity -= 0.75
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                                    continueGame()
                                }
                            }
                            else {
                                flagTapped(number)
                                userTapped = number
                                withAnimation(.easeOut(duration: 0.5)) {
                                    self.offset = 400
                                }
                            }
                            self.disabled = true
                        } label: {
                            Image(countries[number])
                                .renderingMode(.original)
                                .clipShape(Capsule())
                                .shadow(radius: 5)
                        }
                        .rotation3DEffect(.degrees(self.cardSpinAmount), axis: (x: 0, y: number == self.userTapped ? 1 : 0, z: 0))
                        .offset(x: number != correctAnswer ? self.offset : .zero, y: .zero)
                        .opacity(number != self.userTapped ? self.opacity : (1.0))
                        .disabled(self.disabled)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 30)
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text ("Score: \(totalScore)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                
                Spacer()
                
                Text ("Question \(question)")
                    .foregroundColor(.white)
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: continueGame)
        } message: {
            Text("Your score is \(totalScore)")
        }
        .alert(isPresented: $gameOver) {
                    Alert(title: Text("Game over!"), message: Text("Your final score was \(totalScore)/10"), dismissButton: .default(Text("Play again")) {
                        resetGame()
                    })
        }
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            totalScore += 1
        } else {
            scoreTitle = "Wrong, thats the flag of \(countries[number])"
            showingScore = true
        }
    }
    
    func continueGame() {
        if question == 10 {
            gameOver = true
        }
        else {
            self.disabled = false
            self.opacity = 1
            self.offset = .zero
            question += 1
            countries.shuffle()
            correctAnswer = Int.random(in: 0...2)
        }
    }
    
    func resetGame() {
        self.disabled = false
        self.opacity = 1
        self.offset = .zero
        correctAnswer = Int.random(in: 0...2)
        question = 1
        totalScore = 0
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
