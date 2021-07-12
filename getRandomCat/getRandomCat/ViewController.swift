//
//  ViewController.swift
//  getRandomCat
//
//  Created by Галина Збитнева on 10.07.2021.
//

import UIKit

class ViewController: UIViewController {
    
    struct Response: Codable {
        var file: String // важно!! переменную назвать как ключ в json файле  пример  "file": "https://purr.objects-us-east-1.dream.io/i/AwLr7.jpg"
    }
    
   
        //let resourceURl = URL(string: "https://aws.random.cat/meow")
    let catResource = "https://aws.random.cat/meow"
    
   
    //let testCatURL = URL(string: "https://purr.objects-us-east-1.dream.io/i/AwLr7.jpg")

    func getCatHttp(from url: String){
    
        let task = URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: {data, response, error in
            guard let data = data , error == nil else {
                print("something went wrong")
                return
            }
             //значит получили данные
            var result: Response? //создаем переменную типа Response из созданной структуры, которая содержит искомую переменную file
            do{
                result = try JSONDecoder().decode(Response.self, from: data)
            }
            catch{
                print("faild to convert")
            }
            guard let json = result else {
                return
            }
           // print(json.file)// здесь как раз и будет искомая ссылка на рандомную картинку
            let catURL = URL(string: json.file)!
           // print(catURL)
            self.downloadImage(from: catURL) // это функция которая юрл преобразует в картинку
            
        })
        task.resume()
    }
   
    @IBOutlet weak var catImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBAction func findCatButton(_ sender: UIButton) {
        
       getCatHttp(from: catResource)
      
}
    
    func getData (from url: URL, completion: @escaping (Data?, URLResponse?, Error?)->()){
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    private func downloadImage(from url: URL) {
        print("download started")
        getData(from: url){data, response, error in
            guard let data = data, error == nil else {
                return
            }
            print("download finished")
            
            DispatchQueue.main.async {
                [weak self] in
                self?.catImage.image = UIImage(data: data)
            }
        }
    }

    
}
    
    
    
extension UIImageView {
    func loadImageFromURL(url: URL){
        DispatchQueue.global().async {
            [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data){
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                    
                }
                
            }
        }
    }
}


