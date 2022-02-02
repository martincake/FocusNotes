import Foundation

class NoteStorage {
    private var storage = UserDefaults.standard
    private var storageKey = "notes"
    
    func load() -> [Note] {
        var resultNotes: [Note] = []
        let notesFromStorage = storage.array(forKey: storageKey) as? [[String:String]] ?? []
        for note in notesFromStorage {
            guard let title = note["title"] ,
                  let body = note["body"] else {
                      continue
                  }
            resultNotes.append(Note(title: title, body: body))
        }
        return resultNotes
    }
    
    func save(notes: [Note]) {
        var arrayForStorage: [[String:String]] = []
        for note in notes {
            var newElementForStorage: Dictionary<String, String> = [:]
            newElementForStorage["title"] = note.title
            newElementForStorage["body"] = note.body
            arrayForStorage.append(newElementForStorage)
        }
        storage.set(arrayForStorage, forKey: storageKey)
    }
}

struct Note {
    var title: String
    var body: String
}
