import DI

public extension DI {
    var dataService: DataService {
        singleton {
            DataService()
        }
    }
}
