import UIKit

class ViewController: UIViewController {
    
    // MARK: - Настройка состояния элементов UI

    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var bodyTextView: UITextView!
    @IBOutlet weak var button: UIButton!
    
    var titleData = ""
    var bodyData = ""
    var currentNoteNumber: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        roundedCorners(views: [titleTextView, bodyTextView, button])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        titleTextView.text = titleData
        bodyTextView.text = bodyData
    }
    
    private func roundedCorners(views: [UIView]) {
        for view in views {
            view.clipsToBounds = true
            view.layer.cornerRadius = 10
        }
    }
    
    // MARK: - Переход на главный экран с подготовкой и сохранением заметки
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "toMainScreen":
            prepareFirstScreen(segue)
        default:
            break
        }
    }
    
    private func prepareFirstScreen(_ segue: UIStoryboardSegue) {
        var note = Note(title: titleTextView.text, body: bodyTextView.text)
        checkNoteTitle(&note)
        
        guard let destinationController = segue.destination as? MainViewController else {
            return
        }
        if let noteNumber = currentNoteNumber {
            destinationController.notes[noteNumber] = note
        } else {
            destinationController.notes.append(note)
        }
        destinationController.tableView.reloadData()
    }
    
    private func checkNoteTitle(_ note: inout Note) {
        if note.title ==  "" {
            note.title = "Без названия"
        }
    }
}

