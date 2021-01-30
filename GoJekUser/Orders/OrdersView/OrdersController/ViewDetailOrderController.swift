//
//  ViewDetailOrderController.swift
//  GoJekProvider
//
//  Created by Sudar on 19/06/20.
//  Copyright © 2020 Appoets. All rights reserved.
//

import UIKit

class ViewDetailOrderController: UIViewController {
    
    @IBOutlet weak var viewDetailOrderTableview : UITableView!
    @IBOutlet weak var profileImg : UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initailLoad()
    }
    
    private func initailLoad(){
        viewDetailOrderTableview.register(nibName: OrderConstant.ViewDetailOrderCell)

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension ViewDetailOrderController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: OrderConstant.ViewDetailOrderCell, for: indexPath) as! ViewDetailOrderCell

        return cell
    }
    
    
}
