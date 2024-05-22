import Foundation
@propertyWrapper
    struct UserDefault<T: Codable> {
        let key: String
        let defaultValue: T

        init(_ key: String, defaultValue: T) {
            self.key = key
            self.defaultValue = defaultValue
        }

        var wrappedValue: T {
            get {

                if let data = UserDefaults.standard.object(forKey: key) as? Data,
                    let user = try? JSONDecoder().decode(T.self, from: data) {

                    return user

                }

                return  defaultValue
            }
            set {
                if let encoded = try? JSONEncoder().encode(newValue) {
                    UserDefaults.standard.set(encoded, forKey: key)
                }
            }
        }
    }

enum UserDefaultSettings {

    @UserDefault("levels", defaultValue: [1: true, 2: false, 3: false, 4: false, 5: false, 6: false]) static var levels: [Int: Bool]
    @UserDefault("balance", defaultValue: 0) static var balance: Int
    @UserDefault("prices", defaultValue: [1: 0, 2: 500, 3: 1000, 4: 2000, 5: 5000, 6: 10000]) static var prices: [Int: Int]
    @UserDefault("records", defaultValue: [RecordObject(name: "No name", score: 0)]) static var records: [RecordObject]
    @UserDefault("selected", defaultValue: 1) static var selected: Int

}
