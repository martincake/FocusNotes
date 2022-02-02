import UIKit

class MainViewController: UITableViewController {
    
    private var storage: NoteStorage!
    
    var notes = [Note]() {
        didSet {
            storage.save(notes: notes)
        }
    }
    
    @IBAction func addNoteButton(_ sender: UIBarButtonItem) {}
    @IBAction func unwindToFirstScreen(_ segue: UIStoryboardSegue) {}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        storage = NoteStorage()
        loadNotes()
        isAppAlreadyLaunchedOnce()
    }
    
    private func loadNotes() {
        notes = storage.load()
    }
    
    private func isAppAlreadyLaunchedOnce() {
        let defaults = UserDefaults.standard
        guard let _ = defaults.string(forKey: "isAppAlreadyLaunchedOnce") else {
            defaults.set(true, forKey: "isAppAlreadyLaunchedOnce")
            notes.append(Note(
                title: "Это ваша первая заметка",
                body: "Ее можно удалить свайпом влево или изменить по тапу"))
            return
        }
    }

// MARK: - TableView Delegate
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // действие удаления
        let actionDelete = UIContextualAction(style: .destructive, title: "Удалить") { _, _, _ in
            // удаляем контакт
            self.notes.remove(at: indexPath.row)
            // заново формируем табличное представление
            tableView.reloadData()
        }
        // формируем экземпляр, описывающий доступные действия
        let actions = UISwipeActionsConfiguration(actions: [actionDelete])
        return actions
    }

// MARK: - TableView Data Source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let editScreen = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        
        editScreen.titleData = notes[indexPath.row].title
        editScreen.bodyData = notes[indexPath.row].body
        editScreen.currentNoteNumber = indexPath.row
        
        self.navigationController?.pushViewController(editScreen, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        if let reuseCell = tableView.dequeueReusableCell(withIdentifier: "NoteCell") {
            cell = reuseCell
        } else {
            cell = UITableViewCell(style: .default, reuseIdentifier: "NoteCell")
        }
        configure(cell: &cell, for: indexPath)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    private func configure(cell: inout UITableViewCell, for indexPath: IndexPath) {
        var configuration = cell.defaultContentConfiguration()
        configuration.text = notes[indexPath.row].title
        configuration.secondaryText = notes[indexPath.row].body
        cell.contentConfiguration = configuration
        cell.backgroundColor = UIColor.init(red: 233.0/255.0, green: 237.0/255.0, blue: 201.0/255.0, alpha: 1)
    }
}
