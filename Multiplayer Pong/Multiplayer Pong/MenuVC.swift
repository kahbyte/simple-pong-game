import UIKit

var isConnected = false
var isHost = false

class MenuVC: UIViewController {
    
    @IBAction func playButtonTapped(_ sender: Any) {
        moveToGame()
    }
    
    @IBAction func connectButtonTapped(_ sender: Any) {
        showConnectionPrompt()
    }
    
    func moveToGame() {
        let gameVC = self.storyboard?.instantiateViewController(withIdentifier: "GameVC") as! GameViewController
        
        self.navigationController?.pushViewController(gameVC, animated: true)
    }
    
    func showConnectionPrompt() {
        let sessionAlertController = UIAlertController(title: "Local multiplayer", message: "", preferredStyle: .actionSheet)
        
        if !isConnected {
            sessionAlertController.addAction(UIAlertAction(title: "Host session", style: .default, handler: placeholder))
            sessionAlertController.addAction(UIAlertAction(title: "Join a session", style: .default, handler: placeholder))
        } else {
            sessionAlertController.addAction(UIAlertAction(title: "Disconnect", style: .destructive, handler: placeholder))
        }
        
        sessionAlertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(sessionAlertController, animated: true)
        
    }
    
    /*Not important at ALL! Just so I can make the code ready to teach you guys how to use the real functions 😅*/
    func placeholder(action: UIAlertAction) {
    }
}
