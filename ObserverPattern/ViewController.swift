//
//  ViewController.swift
//  ObserverPattern
//
//  Created by Алексей Чигарских on 08.06.2021.
//

import UIKit

class ViewController: UIViewController, Subscriber {
    
    @IBOutlet weak var subscriberInfoLabel: UILabel!
    
    let bloger = Bloger()
    
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
protocol Subscriber : AnyObject {
    func update(subject : Bloger )
}

class Bloger {
    
    var counter : Int = 0
    var lastVideo = ""
    
    private lazy var subscribers : [Subscriber] = [] // Создаем массив с подписчиками
    
    func subscribe(_ subscriber: Subscriber) {
        print("subscribed")
        subscribers.append(subscriber)
    }
    
    func unsubscribe(_ subscriber: Subscriber) {
        print("unsubscribed")
        if let index = subscribers.firstIndex(where: {$0 === subscriber}) {
            subscribers.remove(at: index)
        }
    }
    
    func notify() {
        subscribers.forEach { $0.update(subject: self)
        }
    }
    
    func releaseVideo() {
        counter += 1
        lastVideo = "video" + "\(counter)"
        notify()
        print("released!")
    }
    
}
