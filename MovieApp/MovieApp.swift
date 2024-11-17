import SwiftUI

// Модель фильма
struct Movie: Identifiable {
    let id = UUID()
    let title: String
    let genre: String
    let year: Int
    let rating: Double
    let description: String
    let imageURL: String
}

// Хранилище данных фильмов
class MovieStore: ObservableObject {
    @Published var movies = [
        Movie(
            title: "Интерстеллар",
            genre: "Фантастика",
            year: 2014,
            rating: 8.6,
            description: "Когда засуха, пыльные бури и вымирание растений приводят человечество к продовольственному кризису, коллектив исследователей и учёных отправляется сквозь червоточину в поисках планеты с подходящими для человечества условиями.",
            imageURL: "interstellar"
        ),
        Movie(
            title: "Начало",
            genre: "Фантастика",
            year: 2010,
            rating: 8.7,
            description: "Кобб – талантливый вор, лучший из лучших в опасном искусстве извлечения: он крадет ценные секреты из глубин подсознания во время сна, когда человеческий разум наиболее уязвим.",
            imageURL: "inception"
        ),
        Movie(
            title: "Зеленая миля",
            genre: "Драма",
            year: 1999,
            rating: 9.1,
            description: "Пол Эджкомб — начальник блока смертников в тюрьме «Холодная гора», каждый из узников которого однажды проходит «зеленую милю» по пути к месту казни.",
            imageURL: "green_mile"
        ),
        Movie(
            title: "Побег из Шоушенка",
            genre: "Драма",
            year: 1994,
            rating: 9.1,
            description: "Бухгалтер Энди Дюфрейн обвинён в убийстве собственной жены и её любовника. Оказавшись в тюрьме Шоушенк, он сталкивается с жестокостью и беззаконием, царящими по обе стороны решётки.",
            imageURL: "shawshank"
        )
    ]
    
    func getRandomMovie() -> Movie {
        movies.randomElement() ?? movies[0]
    }
}

// Основной экран
struct ContentView: View {
    @StateObject private var movieStore = MovieStore()
    @State private var currentMovie: Movie?
    @State private var showDetails = false
    @State private var isAnimating = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Фон
                Color.black.edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 20) {
                    // Заголовок
                    Text("Фильм на вечер")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.top, 30)
                    
                    Spacer()
                    
                    // Карточка фильма
                    if let movie = currentMovie {
                        MovieCard(movie: movie)
                            .rotation3DEffect(
                                .degrees(isAnimating ? 360 : 0),
                                axis: (x: 0, y: 1, z: 0)
                            )
                            .onTapGesture {
                                showDetails.toggle()
                            }
                    }
                    
                    Spacer()
                    
                    // Кнопка выбора фильма
                    Button(action: {
                        withAnimation(.spring()) {
                            isAnimating.toggle()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                currentMovie = movieStore.getRandomMovie()
                            }
                        }
                    }) {
                        Text("Подобрать фильм")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [.blue, .purple]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(15)
                            .shadow(radius: 10)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 30)
                }
            }
            .onAppear {
                currentMovie = movieStore.getRandomMovie()
            }
            .sheet(isPresented: $showDetails) {
                if let movie = currentMovie {
                    MovieDetailView(movie: movie)
                }
            }
        }
    }
}

// Карточка фильма
struct MovieCard: View {
    let movie: Movie
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Постер фильма
            Image(movie.imageURL)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 400)
                .clipped()
                .cornerRadius(20)
            
            VStack(alignment: .leading, spacing: 5) {
                // Название фильма
                Text(movie.title)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                HStack {
                    // Жанр
                    Text(movie.genre)
                        .foregroundColor(.gray)
                    Spacer()
                    // Рейтинг
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                        Text(String(format: "%.1f", movie.rating))
                            .foregroundColor(.white)
                    }
                }
            }
            .padding()
        }
        .background(Color.gray.opacity(0.2))
        .cornerRadius(20)
        .padding(.horizontal)
    }
}

// Детальный просмотр фильма
struct MovieDetailView: View {
    let movie: Movie
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Постер фильма
                    Image(movie.imageURL)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 500)
                        .clipped()
                    
                    VStack(alignment: .leading, spacing: 15) {
                        // Информация о фильме
                        Text(movie.title)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        HStack {
                            Text(movie.genre)
                                .foregroundColor(.gray)
                            Text("•")
                                .foregroundColor(.gray)
                            Text("\(movie.year)")
                                .foregroundColor(.gray)
                            Spacer()
                            HStack(spacing: 4) {
                                Image(systemName: "star.fill")
                                    .foregroundColor(.yellow)
                                Text(String(format: "%.1f", movie.rating))
                                    .foregroundColor(.white)
                            }
                        }
                        
                        // Описание
                        Text("Описание")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.top)
                        
                        Text(movie.description)
                            .foregroundColor(.gray)
                            .lineSpacing(5)
                    }
                    .padding()
                }
            }
            
            // Кнопка закрытия
            VStack {
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.gray.opacity(0.5))
                            .clipShape(Circle())
                    }
                    Spacer()
                }
                Spacer()
            }
            .padding()
        }
    }
}

@main
struct MovieApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
