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
        let sessionAlertController = UIAlertController(title: "Multiplayer Local", message: nil, preferredStyle: .actionSheet)
        
        if !isConnected {
            sessionAlertController.addAction(UIAlertAction(title: "Criar uma sessão", style: .default, handler: placeholder))
            sessionAlertController.addAction(UIAlertAction(title: "Entrar em uma sessão", style: .default, handler: placeholder))
        } else {
            sessionAlertController.addAction(UIAlertAction(title: "Desconectar", style: .destructive, handler: placeholder))
        }
        
        
        
        sessionAlertController.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        
        present(sessionAlertController, animated: true)
        
    }
    
    /*Not important at ALL! Just so I can make the code ready to teach you guys how to use the real functions 😅*/
    func placeholder(action: UIAlertAction) {
    }
}
