//
//  AddRegistrationTableViewController.swift
//  HotelManzana
//
//  Created by Brendon Crowe on 2/8/23.
//

import UIKit

class AddRegistrationTableViewController: UITableViewController {
    
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var checkInDateLabel: UILabel!
    @IBOutlet weak var checkInDatePicker: UIDatePicker!
    @IBOutlet weak var checkOutDateLabel: UILabel!
    @IBOutlet weak var checkOutDatePicker: UIDatePicker!
    @IBOutlet weak var numberOfAdultsLabel: UILabel!
    @IBOutlet weak var numberOfAdultsStepper: UIStepper!
    @IBOutlet weak var numberOfChildrenLabel: UILabel!
    @IBOutlet weak var numberOfChildrenStepper: UIStepper!
    @IBOutlet weak var wifiSwitch: UISwitch!
    @IBOutlet weak var roomTypeLabel: UILabel!
    
    // charge labels
    
    @IBOutlet weak var numberOfNightsLabel: UILabel!
    @IBOutlet weak var visitDatesLabel: UILabel!
    @IBOutlet weak var roomCostLabel: UILabel!
    @IBOutlet weak var chargesRoomTypeLabel: UILabel!
    @IBOutlet weak var wifiCostLabel: UILabel!
    @IBOutlet weak var hasWifiLabel: UILabel!
    @IBOutlet weak var totalChargeLabel: UILabel!
    
    var roomType: RoomType?
    
    var existingRegistration: Registration?
    
    var registration: Registration? {
        guard let roomType = roomType,
              let firstName = firstNameTextField.text, !firstName.isEmpty,
              let lastName = lastNameTextField.text, !lastName.isEmpty else { return nil }
        
        let email = emailTextField.text ?? ""
        let checkInDate = checkInDatePicker.date
        let checkOutDate = checkOutDatePicker.date
        let numberOfAdults = Int(numberOfAdultsStepper.value)
        let numberOfChildren = Int(numberOfChildrenStepper.value)
        let hasWifi = wifiSwitch.isOn
        
        return Registration(firstName: firstName, lastName: lastName, emailAddress: email, checkInDate: checkInDate, checkOutDate: checkOutDate, numberOfAdults: numberOfAdults, numberOfChildren: numberOfChildren, wifi: hasWifi, roomType: roomType)
    }
    
    let checkInDateLabelCellIndexPath = IndexPath(row: 0, section: 1) // sets the index path
    let checkInDatePickerCellIndexPath = IndexPath(row: 1, section: 1)
    
    let checkOutDateLabelCellIndexPath = IndexPath(row: 2, section: 1)
    let checkOutDatePickerCellIndexPath = IndexPath(row: 3, section: 1)
    
    var isCheckInDatePickerVisible: Bool = false {
        didSet {
            checkInDatePicker.isHidden = !isCheckInDatePickerVisible
        }
    }
    
    var isCheckOutDatePickerVisible: Bool = false {
        didSet {
            checkOutDatePicker.isHidden = !isCheckOutDatePickerVisible
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadRegistration()
        updateDateViews()
        updateNumberOfGuests()
        updateRoomType()
        updateTotalCharge()
    }
    
    private func loadRegistration() {
        if let existingRegistration = existingRegistration {
            title = "View Guest Registration"
            roomType = existingRegistration.roomType
            firstNameTextField.text = existingRegistration.firstName
            lastNameTextField.text = existingRegistration.lastName
            emailTextField.text = existingRegistration.emailAddress
            checkInDatePicker.date = existingRegistration.checkInDate
            checkOutDatePicker.date = existingRegistration.checkOutDate
            numberOfAdultsStepper.value = Double(existingRegistration.numberOfAdults)
            numberOfChildrenStepper.value = Double(existingRegistration.numberOfChildren)
            wifiSwitch.isOn = existingRegistration.wifi
        } else {
            let midnightToday = Calendar.current.startOfDay(for: Date())
            checkInDatePicker.minimumDate = midnightToday
            checkInDatePicker.date = midnightToday
        }
    }
    
    private func updateTotalCharge() { // call this whenever updates/changes are made to the registration
        let dateRange = Calendar.current.dateComponents([.day], from: checkInDatePicker.date, to: checkOutDatePicker.date) // this gets an array of days
        let numberOfNights = dateRange.day ?? 0 // dateRange.day the total amount of days
        
        numberOfNightsLabel.text = "\(numberOfNights)"
        visitDatesLabel.text = "\(checkInDatePicker.date.formatted(date: .abbreviated, time: .omitted)) - \(checkOutDatePicker.date.formatted(date: .abbreviated, time: .omitted))"
        
        let roomRateTotal: Int
        if let roomType = roomType {
            roomRateTotal = roomType.price * numberOfNights
            roomCostLabel.text = "$\(roomRateTotal)"
            chargesRoomTypeLabel.text = "\(roomType.name) @ $\(roomType.price)/night"
        } else {
            roomRateTotal = 0
            roomCostLabel.text = "--"
            chargesRoomTypeLabel.text = "--"
        }
        
        let wifiTotal: Int
        if wifiSwitch.isOn {
            wifiTotal = 10 * numberOfNights
        } else {
            wifiTotal = 0
        }
        wifiCostLabel.text = "$\(wifiTotal)"
        hasWifiLabel.text = wifiSwitch.isOn ? "Yes" : "No"
        totalChargeLabel.text = "$\(roomRateTotal + wifiTotal)"
        
    }
    
    @IBAction func textFieldChanged(_ sender: UITextField) {
        doneBarButton.isEnabled = existingRegistration == nil && registration != nil
    }
    
    
    private func updateDateViews() { // formatting the date to a String
        checkOutDatePicker.minimumDate = Calendar.current.date(byAdding: .day, value: 1, to: checkInDatePicker.date)
        checkInDateLabel.text = checkInDatePicker.date.formatted(date: .abbreviated, time: .omitted)
        checkOutDateLabel.text = checkOutDatePicker.date.formatted(date: .abbreviated, time: .omitted)
    }
    
    private func updateNumberOfGuests() {
        numberOfAdultsLabel.text = "\(Int(numberOfAdultsStepper.value))"
        numberOfChildrenLabel.text = "\(Int(numberOfChildrenStepper.value))"
    }
    
    private func updateRoomType() {
        if let roomType = roomType {
            roomTypeLabel.text = roomType.name
        } else {
            roomTypeLabel.text = "Not Set"
        }
        doneBarButton.isEnabled = existingRegistration == nil && registration != nil
    }
    
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        updateDateViews()
        updateTotalCharge()
    }
    
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        updateNumberOfGuests()
        updateTotalCharge()
    }
    
    
    @IBAction func wifiSwitchChanged(_ sender: UISwitch) {
        updateTotalCharge()
    }
    
    @IBSegueAction func selectRoomType(_ coder: NSCoder) -> SelectRoomTypeViewController? {
        let selectedRoomTypeController = SelectRoomTypeViewController(coder: coder)
        selectedRoomTypeController?.delegate = self
        selectedRoomTypeController?.roomType = roomType
        return selectedRoomTypeController
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    // This function collapses the Date Pickers, leaving more space for the table view.
    // where acts as an if statement. "This case where ... is true"
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath {
        case checkInDatePickerCellIndexPath where isCheckInDatePickerVisible == false:
            return 0 // return 0 for the height of the checkInDatePicker
        case checkOutDatePickerCellIndexPath where isCheckOutDatePickerVisible == false:
            return 0 // // return 0 for the height of the checkOutDatePicker
        default:
            return UITableView.automaticDimension
        }
    }
    
    // This function sets the row height for the Date Picker
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath {
        case checkInDatePickerCellIndexPath:
            return 190
        case checkOutDatePickerCellIndexPath:
            return 190
        default:
            return UITableView.automaticDimension
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath == checkInDateLabelCellIndexPath && isCheckOutDatePickerVisible == false {
            // check-in label selected, check-out picker is not visible, toggle check-in picker
            isCheckInDatePickerVisible.toggle()
        } else if indexPath == checkOutDateLabelCellIndexPath && isCheckInDatePickerVisible == false {
            // check-out label selected, check-in picker is not visible, toggle check-out picker
            isCheckOutDatePickerVisible.toggle()
        } else if indexPath == checkInDateLabelCellIndexPath || indexPath == checkOutDateLabelCellIndexPath {
            // either label was selected, previous conditions failed meaning at least one picker is visible, toggle both
            isCheckInDatePickerVisible.toggle()
            isCheckOutDatePickerVisible.toggle()
        } else {
            return
        }
        tableView.beginUpdates() // instruct the table view to update itself so that the height for each row is recalculated
        tableView.endUpdates()
    }
}

extension AddRegistrationTableViewController: SelectRoomTypeViewControllerDelegate {
    func selectRoomTypeViewController(_ controller: SelectRoomTypeViewController, didSelect roomType: RoomType) {
        self.roomType = roomType
        updateRoomType()
        updateTotalCharge()
    }
}
