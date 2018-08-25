//
//  ListaTableViewController.swift
//  Exemplo Json e TableView
//
//  Created by Usuário Convidado on 25/08/2018.
//  Copyright © 2018 Julio Augusto. All rights reserved.
//

import UIKit

class ListaTableViewController: UITableViewController {
    
    var aplicativoArray = [Aplicativo]()

    override func viewDidLoad() {
        super.viewDidLoad()

        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let urlApi = "https://itunes.apple.com/br/rss/topfreeapplications/limit=10/json"
        
        if let url = URL(string: urlApi){
            let task = session.dataTask(with: url) { (data, response, error) in
                //todo código aqui será executado quando a execução da task se completa
                if error != nil {
                    print("O erro é: \(error!)")
                    return
                }else if let jsonData = data{
                    do{
                        let parsedJSON = try JSONSerialization.jsonObject(with: jsonData) as! [String:Any]
                        print(parsedJSON)
                        guard let feed = parsedJSON["feed"] as? [String:Any] else { return }
                        guard let apps = feed["entry"] as? [[String:Any]] else { return }
                        for app in apps{
                            let objApp = Aplicativo()
                            // nome do aplicativo
                            guard let imname = app["im:name"] as? [String:Any] else { return }
                            guard let nomeApp = imname["label"] as? String else { return }
                            // imagem string com a URL
                            guard let arrayImage = app["im:image"] as? [Any] else { return }
                            guard let imagem0 = arrayImage[0] as? [String:Any] else { return }
                            guard let imgStr = imagem0["label"] as? String else { return }
                            
                            //Imagem
                            
                            //Transformando uma imagem em data, não é nosso caso
                            //let imagem:UIImage = UIImage(named: "blablabla.png")!
                            //let imagemData2:Data = UIImagePNGRepresentation(imagem)!
                            
                            //outra possibilidade Transformando uma url em data
                            let myUrl = URL(string: imgStr)
                            let imageData:Data = try Data(contentsOf: myUrl!)
                            //transformando o data em Imagem
                            let minhaImagem = UIImage(data: imageData)
                            
                            objApp.nome = nomeApp
                            objApp.imagemSTR = imgStr
                            objApp.imagem = minhaImagem
                            
                            self.aplicativoArray.append(objApp)
                        }
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }catch{
                        print("Error no Parser: \(error)")
                    }
                }
            }
            //disparo da execução da task
            task.resume()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return aplicativoArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        cell.textLabel?.text = aplicativoArray[indexPath.row].nome
        cell.imageView?.image = aplicativoArray[indexPath.row].imagem
        
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
