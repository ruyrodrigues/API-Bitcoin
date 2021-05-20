import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    //MARK:- Outlets
    
    @IBOutlet weak var PriceView: UILabel!
    
    @IBOutlet weak var CurrencyPV: UIPickerView!
    
    //MARK:- Variables
    
    let apiKey = "ZTllMzIwZGMxN2M1NGM3ZmEzODc5MmQ5MzVjYmU1YjA"
    let curruncies = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    let baseUrl = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTCAUD"
    
    
    //var url = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC\(curruncies[row])"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CurrencyPV.delegate = self
        CurrencyPV.dataSource = self
        
        fetchData(url: baseUrl)
    }
    
    func formatNumberToDecimal(value:Double) -> String {
        let numberFormatter = NumberFormatter()

        // Atribuindo o locale desejado
        numberFormatter.locale = Locale(identifier: "pt_BR")

        // Importante para que sejam exibidas as duas casas após a vírgula
        numberFormatter.minimumFractionDigits = 2

        numberFormatter.numberStyle = .decimal

        return numberFormatter.string(from: NSNumber(value:value)) ?? "Valor indefinido"
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
              return 1
           }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            
             return curruncies.count
          }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        let url = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC\(curruncies[row])"
        
        fetchData(url: url)
        
        
        return curruncies[row]
       }
    
    func fetchData(url: String) {
        
        let url = URL(string: url)!
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        
        request.addValue(apiKey, forHTTPHeaderField: "x-ba-key")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let data = data{
                self.parseJSON(json: data)
                
            } else {
            print(error!)
        }
            
        }
        
        task.resume()
}
    func parseJSON(json: Data) {
            
        do {

                    if let json = try JSONSerialization.jsonObject(with: json, options: .mutableContainers) as? [String: Any] {
                        print(json)
                        if let askValue = json["ask"] as? NSNumber {
                            print(askValue)
         
                            let askvalueString = "\(askValue)"
                            DispatchQueue.main.async {

                                self.PriceView.text = self.formatNumberToDecimal(value: Double(askvalueString)!)
                            }
                            print("success")
                            
                        } else {
                                            print("error")
                                        }
                                    }
                                } catch {

                                    print("error parsing json: \(error)")
                                }
        }
}
