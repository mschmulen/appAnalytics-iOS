//
//  GenericTableViewController.swift
//

import UIKit

//class GenericTableViewCell: UITableViewCell {
//
//    static var reuseIdentifier:String { return "GenericTableViewCell" }
//
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    }
//}
//
//public class GenericTableViewController<T:VaporModel>: UITableViewController {
//
//    public var viewModel: GenericTableViewController.ViewModel!
//    public var mock:T?
//
//    public var selectionCallback: ((_ record: String) -> Void)?
//
//
//    // private var adapter: GenericTableAdapter<T, GenericTableViewCell>!
//    let service = VaporNetworkService<T>()
//    private var records: [T] = []
//
//
//    override public func viewDidLoad() {
//        super.viewDidLoad()
//
//        title = "<\(String(describing: T.self))>"
//
////        adapter = GenericTableAdapter<T, GenericTableViewCell>(enableSlideToDelete: false)
////        tableView.dataSource = adapter
////        tableView.delegate = adapter
////        tableView.register(cellType: GenericTableViewCell.self)
////
////        self.service = GenericService<T>()
////        adapter.configure = { model, cell in
////            cell.textLabel?.text =  "\(model.titleInfo)"
////            cell.detailTextLabel?.text = "\(model.detailInfo)"
////        }
////        adapter.selectCallback = { record in //[weak self]
////            if self.viewModel.canShowDetail == true {
////                let detailViewModel = GenericDetailTableViewController<T>.ViewModel(record: record)
////                let detailViewController = GenericDetailTableViewController<T>.instantiate(detailViewModel)
////                self.navigationController?.pushViewController(detailViewController, animated: true)
////            }
////        }
////
////        adapter.deleteCallback = { record in //[weak self]
////            print("delete \(record)")
////            // MAS TODO First Confirm with an Alert OK, CANCEL
////            //            self.service.deleteRecord(record: record
////            //                , deleteResult: { (result, error) in
////            //                    print( "delete this record ")
////            //            })
////        }
//
//        if viewModel.canAdd == true {
//            let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
//            let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
//            toolbarItems = [add, spacer]
//        }
//
//        navigationController?.setToolbarHidden(false, animated: false)
//
//        refreshControl = UIRefreshControl()
//        refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh")
//        refreshControl?.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
//        refresh()
//    }
//
//    public override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(true)
//    }
//
//    override public func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//
//    }
//
//    override public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return records.count
//    }
//
//    override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let model = records[indexPath.row]
//        let cell = GenericTableViewCell(style: .subtitle, reuseIdentifier: GenericTableViewCell.reuseIdentifier)
//        cell.textLabel?.text = "\(String(describing: model.id))"            // "\(model.titleInfo)"
//        cell.detailTextLabel?.text =  "\(model)"
//        return cell
//    }
//
//    override public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("didSelectRowAt")
//    }
//
////    override public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
////         return false
////    }
////
////    override public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
////        fatalError("editingStyle")
////    }
//
//    @objc func handleRefresh() {
//        refreshControl?.beginRefreshing()
//        refresh()
//    }
//
//    func refresh() {
//        //        service.fetchAllRecords { [weak self] (records, error) in
//        //            self?.handle(records: records as [T])
//        //            DispatchQueue.main.async {
//        //                self?.refreshControl?.endRefreshing()
//        //            }
//        //        }
//
//        service.loadGeneric { (models) in
//            print( "models \(String(describing: models))")
//
//            if let models = models {
//                self.records = []
//                for model in models {
//                    self.records.append(model)
//                }
//            }
//            DispatchQueue.main.async {
//                self.tableView.reloadData()
//                self.refreshControl?.endRefreshing()
//            }
//        }
//    }
//
////    func handle(records: [T]) {
////        print( "records.count \(records.count)")
////        adapter.items = records
////        DispatchQueue.main.async {
////            self.tableView.reloadData()
////        }
////    }
//
//    @IBAction func addTapped(_ sender: Any) {
//        // showAlert("addTapped")
//        if let newModel = mock {
//            service.createGeneric(model: newModel) { (model, error) in
//                print( "response \(String(describing: model)) \nerror:\(String(describing: error))")
//                self.refresh()
//            }
//        }
//    }
//}
//
//public extension GenericTableViewController {
//
//    func showAlert(_ message:String, title:String = "Error" ){
//        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
//        self.present(alert, animated: true, completion: nil)
//    }
//}
//
//extension GenericTableViewController {
//
//    public class func instantiate(_ viewData: ViewModel, mock:T) -> UIViewController {
//        let vc = GenericTableViewController(style: .plain)
//        vc.viewModel = viewData
//        vc.mock = mock
//        return vc
//    }
//}
//
//public extension GenericTableViewController {
//
//    struct ViewModel {
//
//        let resultsLimit:Int
//        let canAdd:Bool
//        let canShowDetail:Bool
//
//        /// mock factory
//        public static var mock: ViewModel {
//            return ViewModel(resultsLimit: 100, canAdd: true, canShowDetail: true)
//        }
//
////        public static func create( records:[GenericRecordProtocol]) -> ViewModel {
////            return ViewModel(resultsLimit: 100, canAdd: true, canShowDetail: true , specificReferences: records)
////        }
//    }
//
//}


