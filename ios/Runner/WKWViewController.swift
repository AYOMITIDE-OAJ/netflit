//
//  WKWViewController.swift
//  Runner
//
//  Created by Goldenmace on 13/02/21.
//

import UIKit
import WebKit
import Flutter

class WKWViewController: UIViewController,WKNavigationDelegate,WKUIDelegate,UIScrollViewDelegate {
    
    @IBOutlet weak var vwMain: UIView!
    var window = UIWindow()
    var webView: WKWebView!
    var dic = NSMutableDictionary()
    var islogin = Bool()
    private var currentBackForwardItem: WKBackForwardListItem?
    override func viewDidLoad() {
        super.viewDidLoad()
        webView = WKWebView()
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        self.vwMain.addSubview(webView)
        islogin = (dic.value(forKey: "isLoggedIn") != nil)
        let link = URL(string:dic["url"] as! String)!
        let request = URLRequest(url: link)
        webView.load(request)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLayoutSubviews() {
            webView.frame = CGRect(x: 0, y: 0, width: self.vwMain.frame.size.width, height: self.vwMain.frame.size.height)
    }
    
    //MARK:-
    //MARK:- WKNavigationDelegate
    
    private func handleBackForwardWebView(navigationAction: WKNavigationAction) {
        if navigationAction.navigationType == .backForward {
            let isBack = webView.backForwardList.backList
                .filter { $0 == currentBackForwardItem }
                .count == 0

            if isBack {
                let logJS = "var check = document.getElementsByClassName('pms-account-navigation-link--logout');" +
                "if (check.length > 0) {" +

                "document.querySelector('.pms-account-navigation-link--logout a').click();" +
                "}"
                webView.evaluateJavaScript(logJS, completionHandler: nil)
            } else {

            }
        }

        currentBackForwardItem = webView.backForwardList.currentItem
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            handleBackForwardWebView(navigationAction: navigationAction)
             decisionHandler(.allow)
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if islogin {
            let username = dic .value(forKey: "username")
            let pass = dic.value(forKey: "password")
            let user = "document.getElementById('user_login').value ='\(username ?? "")'"
            let pwd = "document.getElementById('user_pass').value = '\(pass ?? "")'"
            let login = "document.getElementById('pms_login').submit()"
            webView.evaluateJavaScript(user, completionHandler: nil)
            webView.evaluateJavaScript(pwd, completionHandler: nil)
            webView.evaluateJavaScript(login, completionHandler: nil)
        }
        islogin = false
    }
    
    //MARK:-
    //MARK:- UIButton Clicked events
    
    @IBAction func btnMenu_Clicked(_ sender: UIButton) {
//        if let viewControllers = self.navigationController?.viewControllers {
//               for vc in viewControllers {
//                    if vc.isKind(of: FlutterViewController.classForCoder()) {
//                        self.navigationController?.popViewController(animated: true)
//                         //Your Process
//                    }
//               }
//         }
        self.navigationController?.popViewController(animated: true)
//    self.dismiss(animated: true, completion: nil)
    }
}
