import UIKit

class ViewController: UIViewController, Subscriber {
    
    @IBOutlet weak var subscriberInfoLabel: UILabel!
    
    var bloger = Bloger()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bloger.subscribe(self)
    }

    @IBAction func publishButton(_ sender: Any) {
        bloger.releaseVideo()
    }
    @IBAction func subscribeToggle(_ sender: Any) {
        if (sender as AnyObject).isOn {
            bloger.subscribe(self)
        } else {
            bloger.unsubscribe(self)
        }
    }
    
    func update(subject: Bloger) {
        subscriberInfoLabel.text = subject.lastVideo
    }
}

//MARK:- Protocols
protocol Subscriber : UIViewController {
    func update(subject : Bloger )
}

//Fix retain cycle
struct WeakSubscriber { // структура служит для хранения объекта со слабой ссылкой
    weak var value : Subscriber?
}

class Bloger {
    
    private lazy var subscribers : [WeakSubscriber] = [] // Создаем массив с подписчиками
    
    var counter : Int = 0
    var lastVideo = ""
    
    func subscribe(_ subscriber: Subscriber) {
        print("subscribed")
        subscribers.append(WeakSubscriber(value: subscriber))
    }
    
    func unsubscribe(_ subscriber: Subscriber) {
        subscribers.removeAll(where: { $0.value === subscriber })
        print("unsubscribed")
    }
    
    func notify() {
        subscribers.forEach { $0.value?.update(subject: self)
        }
    }
    
    func releaseVideo() {
        counter += 1
        lastVideo = "video" + "\(counter)"
        notify()
        print("released!")
    }
    
}
