//
//  ConfigurationScrollView.swift
//  test-smartboxtv
//
//  Created by Ing. Richard José David González on 13/5/16.
//  Copyright © 2016 Ing. Richard David. All rights reserved.
//

import UIKit

/**
 Class that contains the configuration of UIScrollView component responsible for deploying football teams.
 */
class ConfigurationScrollView {
    
    //MARK: - Objects, Variables and Constants.
    
    ///Component UIScrollView to show football teams.
    var scrollView: UIScrollView = UIScrollView()
    
    //MARK: - Functions: Self.
    
    ///Function containing the initial configuration of UIScrollView component.
    private func configScrollView() {
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    /**
     Settings for iPhone devices.
     - parameter mainView (UIViewController): Controller where the UIScrollView is shown.
     - parameter teams ([Team]): Array football teams.
     */
    func iphoneDevice(mainView: UIViewController, teams: [Team]) {
        
        self.configScrollView()
        mainView.view.addSubview(self.scrollView)
        
        var constraints: [NSLayoutConstraint] = [NSLayoutConstraint]()
        
        constraints.append(NSLayoutConstraint(
            item: self.scrollView,
            attribute: NSLayoutAttribute.Top,
            relatedBy: NSLayoutRelation.Equal,
            toItem: mainView.topLayoutGuide,
            attribute: NSLayoutAttribute.Bottom,
            multiplier: 1,
            constant: 0
            ))
        
        constraints.append(NSLayoutConstraint(
            item: mainView.view,
            attribute: NSLayoutAttribute.Bottom,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self.scrollView,
            attribute: NSLayoutAttribute.Bottom,
            multiplier: 1,
            constant: 0))
        
        constraints.append(NSLayoutConstraint(
            item: self.scrollView,
            attribute: NSLayoutAttribute.Leading,
            relatedBy: NSLayoutRelation.Equal,
            toItem: mainView.view,
            attribute: NSLayoutAttribute.Leading,
            multiplier: 1,
            constant: 0))
        
        constraints.append(NSLayoutConstraint(
            item: mainView.view,
            attribute: NSLayoutAttribute.Trailing,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self.scrollView,
            attribute: NSLayoutAttribute.Trailing,
            multiplier: 1,
            constant: 0))
        
        mainView.view.addConstraints(constraints)
        
        var yPosition: CGFloat = 10
        
        for index in 1...teams.count {
            
            let view: UIView = UIView()
            view.layer.borderWidth = 1
            view.layer.borderColor = UIColor.blackColor().CGColor
            view.translatesAutoresizingMaskIntoConstraints = false
            view.addConstraint(NSLayoutConstraint(
                item: view,
                attribute: NSLayoutAttribute.Height,
                relatedBy: NSLayoutRelation.Equal,
                toItem: view,
                attribute: NSLayoutAttribute.Height,
                multiplier: 0,
                constant: 130))
            self.scrollView.addSubview(view)
            
            constraints.removeAll()
            
            constraints.append(NSLayoutConstraint(
                item: view,
                attribute: NSLayoutAttribute.Top,
                relatedBy: NSLayoutRelation.Equal,
                toItem: self.scrollView,
                attribute: NSLayoutAttribute.Top,
                multiplier: 1,
                constant: yPosition
                ))
            
            if (index == teams.count) {
                constraints.append(NSLayoutConstraint(
                    item: self.scrollView,
                    attribute: NSLayoutAttribute.Bottom,
                    relatedBy: NSLayoutRelation.Equal,
                    toItem: view,
                    attribute: NSLayoutAttribute.Bottom,
                    multiplier: 1,
                    constant: 10))
            }
            
            constraints.append(NSLayoutConstraint(
                item: view,
                attribute: NSLayoutAttribute.Leading,
                relatedBy: NSLayoutRelation.Equal,
                toItem: self.scrollView,
                attribute: NSLayoutAttribute.Leading,
                multiplier: 1,
                constant: 10))
            
            constraints.append(NSLayoutConstraint(
                item: view,
                attribute: NSLayoutAttribute.Trailing,
                relatedBy: NSLayoutRelation.Equal,
                toItem: self.scrollView,
                attribute: NSLayoutAttribute.Trailing,
                multiplier: 1,
                constant: 10))
            
            constraints.append(NSLayoutConstraint(
                item: view,
                attribute: NSLayoutAttribute.CenterX,
                relatedBy: NSLayoutRelation.Equal,
                toItem: self.scrollView,
                attribute: NSLayoutAttribute.CenterX,
                multiplier: 1,
                constant: 0))
            
            self.scrollView.addConstraints(constraints)
            
            yPosition += 130 + 5
            
            constraints.removeAll()
            
            let imageView: UIImageView = UIImageView()
            Functions.loadImage(imageView, urlImage: teams[index-1].shield!)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.addConstraint(NSLayoutConstraint(
                item: imageView,
                attribute: NSLayoutAttribute.Height,
                relatedBy: NSLayoutRelation.Equal,
                toItem: imageView,
                attribute: NSLayoutAttribute.Height,
                multiplier: 0,
                constant: 70))
            imageView.addConstraint(NSLayoutConstraint(
                item: imageView,
                attribute: NSLayoutAttribute.Width,
                relatedBy: NSLayoutRelation.Equal,
                toItem: imageView,
                attribute: NSLayoutAttribute.Width,
                multiplier: 0,
                constant: 70))
            view.addSubview(imageView)
            
            constraints.append(NSLayoutConstraint(
                item: imageView,
                attribute: NSLayoutAttribute.CenterY,
                relatedBy: NSLayoutRelation.Equal,
                toItem: view,
                attribute: NSLayoutAttribute.CenterY,
                multiplier: 1,
                constant: 0
                ))
            
            constraints.append(NSLayoutConstraint(
                item: imageView,
                attribute: NSLayoutAttribute.Leading,
                relatedBy: NSLayoutRelation.Equal,
                toItem: view,
                attribute: NSLayoutAttribute.Leading,
                multiplier: 1,
                constant: 8
                ))
            
            let lblName: UILabel = UILabel()
            lblName.text = teams[index-1].name!
            lblName.textColor = UIColor.blackColor()
            lblName.font = UIFont(name: Styles.typeFont, size: Styles.typeFontSize)
            lblName.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(lblName)
            
            constraints.append(NSLayoutConstraint(
                item: lblName,
                attribute: NSLayoutAttribute.Top,
                relatedBy: NSLayoutRelation.Equal,
                toItem: imageView,
                attribute: NSLayoutAttribute.Top,
                multiplier: 1,
                constant: 12
                ))
            
            constraints.append(NSLayoutConstraint(
                item: lblName,
                attribute: NSLayoutAttribute.Leading,
                relatedBy: NSLayoutRelation.Equal,
                toItem: imageView,
                attribute: NSLayoutAttribute.Trailing,
                multiplier: 1,
                constant: 10
                ))
            
            let lblPosition: UILabel = UILabel()
            lblPosition.text = "Posición:"
            lblPosition.textColor = UIColor.blackColor()
            lblPosition.font = UIFont(name: Styles.typeFont, size: Styles.typeFontSize)
            lblPosition.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(lblPosition)
            
            constraints.append(NSLayoutConstraint(
                item: lblPosition,
                attribute: NSLayoutAttribute.Top,
                relatedBy: NSLayoutRelation.Equal,
                toItem: lblName,
                attribute: NSLayoutAttribute.Bottom,
                multiplier: 1,
                constant: 17
                ))
            
            constraints.append(NSLayoutConstraint(
                item: lblPosition,
                attribute: NSLayoutAttribute.Leading,
                relatedBy: NSLayoutRelation.Equal,
                toItem: lblName,
                attribute: NSLayoutAttribute.Leading,
                multiplier: 1,
                constant: 0
                ))
            
            let lblNumberPosition: UILabel = UILabel()
            lblNumberPosition.text = String(teams[index-1].position!)
            lblNumberPosition.textColor = UIColor.blackColor()
            lblNumberPosition.font = UIFont(name: Styles.typeFontBold, size: Styles.typeFontSize)
            lblNumberPosition.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(lblNumberPosition)
            
            constraints.append(NSLayoutConstraint(
                item: lblNumberPosition,
                attribute: NSLayoutAttribute.Leading,
                relatedBy: NSLayoutRelation.Equal,
                toItem: lblPosition,
                attribute: NSLayoutAttribute.Trailing,
                multiplier: 1,
                constant: 1
                ))
            
            constraints.append(NSLayoutConstraint(
                item: lblNumberPosition,
                attribute: NSLayoutAttribute.CenterY,
                relatedBy: NSLayoutRelation.Equal,
                toItem: lblPosition,
                attribute: NSLayoutAttribute.CenterY,
                multiplier: 1,
                constant: 0
                ))
            
            let lblPoints: UILabel = UILabel()
            lblPoints.text = "Puntos:"
            lblPoints.textColor = UIColor.blackColor()
            lblPoints.font = UIFont(name: Styles.typeFont, size: Styles.typeFontSize)
            lblPoints.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(lblPoints)
            
            constraints.append(NSLayoutConstraint(
                item: lblPoints,
                attribute: NSLayoutAttribute.Top,
                relatedBy: NSLayoutRelation.Equal,
                toItem: view,
                attribute: NSLayoutAttribute.Top,
                multiplier: 1,
                constant: 15
                ))
            
            constraints.append(NSLayoutConstraint(
                item: view,
                attribute: NSLayoutAttribute.Trailing,
                relatedBy: NSLayoutRelation.Equal,
                toItem: lblPoints,
                attribute: NSLayoutAttribute.Trailing,
                multiplier: 1,
                constant: 20
                ))
            
            let lblNumberPoints: UILabel = UILabel()
            lblNumberPoints.text = String(teams[index-1].results!.points!)
            lblNumberPoints.textColor = UIColor.blackColor()
            lblNumberPoints.font = UIFont(name: Styles.typeFontBold, size: Styles.typeFontSize + 15)
            lblNumberPoints.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(lblNumberPoints)
            
            constraints.append(NSLayoutConstraint(
                item: lblNumberPoints,
                attribute: NSLayoutAttribute.Top,
                relatedBy: NSLayoutRelation.Equal,
                toItem: lblPoints,
                attribute: NSLayoutAttribute.Bottom,
                multiplier: 1,
                constant: 20
                ))
            
            constraints.append(NSLayoutConstraint(
                item: lblNumberPoints,
                attribute: NSLayoutAttribute.CenterX,
                relatedBy: NSLayoutRelation.Equal,
                toItem: lblPoints,
                attribute: NSLayoutAttribute.CenterX,
                multiplier: 1,
                constant: 0
                ))
            
            view.addConstraints(constraints)
            
        }
        
    }
    
    /**
     Settings for iPad (Portrait) devices.
     - parameter mainView (UIViewController): Controller where the UIScrollView is shown.
     - parameter teams ([Team]): Array football teams.
     */
    func ipadDevicePortrait(mainView: UIViewController, teams: [Team]){
        
        self.configScrollView()
        mainView.view.addSubview(self.scrollView)
        
        var constraints: [NSLayoutConstraint] = [NSLayoutConstraint]()
        
        constraints.append(NSLayoutConstraint(
            item: self.scrollView,
            attribute: NSLayoutAttribute.Top,
            relatedBy: NSLayoutRelation.Equal,
            toItem: mainView.topLayoutGuide,
            attribute: NSLayoutAttribute.Bottom,
            multiplier: 1,
            constant: 0
            ))
        
        constraints.append(NSLayoutConstraint(
            item: mainView.view,
            attribute: NSLayoutAttribute.Bottom,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self.scrollView,
            attribute: NSLayoutAttribute.Bottom,
            multiplier: 1,
            constant: 0))
        
        constraints.append(NSLayoutConstraint(
            item: self.scrollView,
            attribute: NSLayoutAttribute.Leading,
            relatedBy: NSLayoutRelation.Equal,
            toItem: mainView.view,
            attribute: NSLayoutAttribute.Leading,
            multiplier: 1,
            constant: 0))
        
        constraints.append(NSLayoutConstraint(
            item: mainView.view,
            attribute: NSLayoutAttribute.Trailing,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self.scrollView,
            attribute: NSLayoutAttribute.Trailing,
            multiplier: 1,
            constant: 0))
        
        mainView.view.addConstraints(constraints)
        
        constraints.removeAll()
        
        var indicator: Int = 0
        var iterator: Int = 0
        
        if ((teams.count % 2) == 0) {
            iterator = (teams.count/2)
        } else {
            iterator = (teams.count/2) + (teams.count%2)
        }

        var yPosition: CGFloat = 10
        
        for index in 1...iterator {

            let viewiPadPortrait = NSBundle.mainBundle().loadNibNamed("StructureViewForiPad", owner: self.scrollView, options: nil).first as? ViewiPadPortrait
            viewiPadPortrait!.viewOne.layer.borderWidth = 1
            viewiPadPortrait!.viewOne.layer.borderColor = UIColor.blackColor().CGColor
            Functions.loadImage(viewiPadPortrait!.imgViewOne, urlImage: teams[indicator].shield!)
            viewiPadPortrait!.lblNameViewOne.text = teams[indicator].name!
            viewiPadPortrait!.lblNumberPositionViewOne.text = String(teams[indicator].position!)
            viewiPadPortrait!.lblPointsViewOne.text = String(teams[indicator].results!.points!)
            if (index == iterator && (index%2) != 0) {
                viewiPadPortrait!.viewTwo.hidden = true
            } else {
                viewiPadPortrait!.viewTwo.layer.borderWidth = 1
                viewiPadPortrait!.viewTwo.layer.borderColor = UIColor.blackColor().CGColor
                Functions.loadImage(viewiPadPortrait!.imgViewTwo, urlImage: teams[indicator+1].shield!)
                viewiPadPortrait!.lblNameViewTwo.text = teams[indicator+1].name!
                viewiPadPortrait!.lblNumberPositionViewTwo.text = String(teams[indicator+1].position!)
                viewiPadPortrait!.lblPointsViewTwo.text = String(teams[indicator+1].results!.points!)
            }
            indicator = indicator + 2
            viewiPadPortrait!.addConstraint(NSLayoutConstraint(
                item: viewiPadPortrait!,
                attribute: NSLayoutAttribute.Height,
                relatedBy: NSLayoutRelation.Equal,
                toItem: viewiPadPortrait!,
                attribute: NSLayoutAttribute.Height,
                multiplier: 0,
                constant: 150))
            viewiPadPortrait!.translatesAutoresizingMaskIntoConstraints = false
            
            self.scrollView.addSubview(viewiPadPortrait!)
            
            if (index == 1) {
                constraints.append(NSLayoutConstraint(
                    item: viewiPadPortrait!,
                    attribute: NSLayoutAttribute.CenterX,
                    relatedBy: NSLayoutRelation.Equal,
                    toItem: self.scrollView,
                    attribute: NSLayoutAttribute.CenterX,
                    multiplier: 1,
                    constant: 0))
            }
            
            constraints.append(NSLayoutConstraint(
                item: self.scrollView,
                attribute: NSLayoutAttribute.Trailing,
                relatedBy: NSLayoutRelation.Equal,
                toItem: viewiPadPortrait!,
                attribute: NSLayoutAttribute.Trailing,
                multiplier: 1,
                constant: 10))
            
            constraints.append(NSLayoutConstraint(
                item: viewiPadPortrait!,
                attribute: NSLayoutAttribute.Leading,
                relatedBy: NSLayoutRelation.Equal,
                toItem: self.scrollView,
                attribute: NSLayoutAttribute.Leading,
                multiplier: 1,
                constant: 10))
            
            constraints.append(NSLayoutConstraint(
                item: viewiPadPortrait!,
                attribute: NSLayoutAttribute.Top,
                relatedBy: NSLayoutRelation.Equal,
                toItem: self.scrollView,
                attribute: NSLayoutAttribute.Top,
                multiplier: 1,
                constant: yPosition))
            
            if (index == iterator) {
                constraints.append(NSLayoutConstraint(
                    item: self.scrollView,
                    attribute: NSLayoutAttribute.Bottom,
                    relatedBy: NSLayoutRelation.Equal,
                    toItem: viewiPadPortrait!,
                    attribute: NSLayoutAttribute.Bottom,
                    multiplier: 1,
                    constant: 10))
            }
            
            self.scrollView.addConstraints(constraints)
            
            yPosition += 150 + 5
        
        }
        
    }
    
    /**
     Settings for iPad (Landscape) devices.
     - parameter mainView (UIViewController): Controller where the UIScrollView is shown.
     - parameter teams ([Team]): Array football teams.
     */
    func ipadDeviceLandscape(mainView: UIViewController, teams: [Team]){
        
        self.configScrollView()
        mainView.view.addSubview(self.scrollView)
        
        var constraints: [NSLayoutConstraint] = [NSLayoutConstraint]()
        
        constraints.append(NSLayoutConstraint(
            item: self.scrollView,
            attribute: NSLayoutAttribute.Top,
            relatedBy: NSLayoutRelation.Equal,
            toItem: mainView.topLayoutGuide,
            attribute: NSLayoutAttribute.Bottom,
            multiplier: 1,
            constant: 0
            ))
        
        constraints.append(NSLayoutConstraint(
            item: mainView.view,
            attribute: NSLayoutAttribute.Bottom,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self.scrollView,
            attribute: NSLayoutAttribute.Bottom,
            multiplier: 1,
            constant: 0))
        
        constraints.append(NSLayoutConstraint(
            item: self.scrollView,
            attribute: NSLayoutAttribute.Leading,
            relatedBy: NSLayoutRelation.Equal,
            toItem: mainView.view,
            attribute: NSLayoutAttribute.Leading,
            multiplier: 1,
            constant: 0))
        
        constraints.append(NSLayoutConstraint(
            item: mainView.view,
            attribute: NSLayoutAttribute.Trailing,
            relatedBy: NSLayoutRelation.Equal,
            toItem: self.scrollView,
            attribute: NSLayoutAttribute.Trailing,
            multiplier: 1,
            constant: 0))
        
        mainView.view.addConstraints(constraints)
        
        constraints.removeAll()
        
        var iterator: Int = 0
        
        if ((teams.count % 3) == 0) {
            iterator = (teams.count/3)
        } else {
            iterator = (teams.count/3) + 1
        }
        
        var yPosition: CGFloat = 10
        var selectedView: Bool = true
        var numberOfRecords: Int = teams.count
        var numberOfRecordsToShow: Int = 0
        
        for index in 1...iterator {
            
            var viewiPadLandscape: UIView = UIView()
            var viewiPadLandscapeOne: ViewOne?
            var viewiPadLandscapeTwo: ViewTwo?
            
            if (selectedView == true) {
                
                viewiPadLandscapeOne = NSBundle.mainBundle().loadNibNamed("StructureViewForiPad", owner: self.scrollView, options: nil)[1] as? ViewOne
                
                if (numberOfRecords == 0) {
                    viewiPadLandscapeOne!.viewOne.hidden = true
                } else {
                    
                    viewiPadLandscapeOne!.viewOne.layer.borderWidth = 1
                    viewiPadLandscapeOne!.viewOne.layer.borderColor = UIColor.blackColor().CGColor
                    Functions.loadImage(viewiPadLandscapeOne!.imgViewOne, urlImage: teams[numberOfRecordsToShow].shield!)
                    viewiPadLandscapeOne!.lblNameViewOne.text = teams[numberOfRecordsToShow].name!
                    viewiPadLandscapeOne!.lblNumberPositionViewOne.text = String(teams[numberOfRecordsToShow].position!)
                    viewiPadLandscapeOne!.lblPointsViewOne.text = String(teams[numberOfRecordsToShow].results!.points!)
                    numberOfRecordsToShow = numberOfRecordsToShow + 1
                    numberOfRecords = numberOfRecords - 1
                
                }
                
                if (numberOfRecords == 0) {
                    viewiPadLandscapeOne!.viewTwo.hidden = true
                } else {
                    
                    viewiPadLandscapeOne!.viewTwo.layer.borderWidth = 1
                    viewiPadLandscapeOne!.viewTwo.layer.borderColor = UIColor.blackColor().CGColor
                    Functions.loadImage(viewiPadLandscapeOne!.imgViewTwo, urlImage: teams[numberOfRecordsToShow].shield!)
                    viewiPadLandscapeOne!.lblNameViewTwo.text = teams[numberOfRecordsToShow].name!
                    viewiPadLandscapeOne!.lblNumberPositionViewTwo.text = String(teams[numberOfRecordsToShow].position!)
                    viewiPadLandscapeOne!.lblPointsViewTwo.text = String(teams[numberOfRecordsToShow].results!.points!)
                    numberOfRecordsToShow = numberOfRecordsToShow + 1
                    numberOfRecords = numberOfRecords - 1
                
                }
                
                if (numberOfRecords == 0) {
                    viewiPadLandscapeOne!.viewThree.hidden = true
                } else {
                    
                    viewiPadLandscapeOne!.viewThree.layer.borderWidth = 1
                    viewiPadLandscapeOne!.viewThree.layer.borderColor = UIColor.blackColor().CGColor
                    Functions.loadImage(viewiPadLandscapeOne!.imgViewThree, urlImage: teams[numberOfRecordsToShow].shield!)
                    viewiPadLandscapeOne!.lblNameViewThree.text = teams[numberOfRecordsToShow].name!
                    viewiPadLandscapeOne!.lblNumberPositionViewThree.text = String(teams[numberOfRecordsToShow].position!)
                    viewiPadLandscapeOne!.lblPointsViewThree.text = String(teams[numberOfRecordsToShow].results!.points!)
                    numberOfRecordsToShow = numberOfRecordsToShow + 1
                    numberOfRecords = numberOfRecords - 1
                
                }
                
                selectedView = false
                viewiPadLandscape = viewiPadLandscapeOne!
                
            } else {
                
                viewiPadLandscapeTwo = NSBundle.mainBundle().loadNibNamed("StructureViewForiPad", owner: self.scrollView, options: nil)[2] as? ViewTwo
                
                if (numberOfRecords == 0) {
                    viewiPadLandscapeTwo!.viewOne.hidden = true
                } else {
                    
                    viewiPadLandscapeTwo!.viewOne.layer.borderWidth = 1
                    viewiPadLandscapeTwo!.viewOne.layer.borderColor = UIColor.blackColor().CGColor
                    Functions.loadImage(viewiPadLandscapeTwo!.imgViewOne, urlImage: teams[numberOfRecordsToShow].shield!)
                    viewiPadLandscapeTwo!.lblNameViewOne.text = teams[numberOfRecordsToShow].name!
                    viewiPadLandscapeTwo!.lblNumberPositionViewOne.text = String(teams[numberOfRecordsToShow].position!)
                    viewiPadLandscapeTwo!.lblPointsViewOne.text = String(teams[numberOfRecordsToShow].results!.points!)
                    numberOfRecordsToShow = numberOfRecordsToShow + 1
                    numberOfRecords = numberOfRecords - 1
                    
                }
                
                if (numberOfRecords == 0) {
                    viewiPadLandscapeTwo!.viewTwo.hidden = true
                } else {
                    
                    viewiPadLandscapeTwo!.viewTwo.layer.borderWidth = 1
                    viewiPadLandscapeTwo!.viewTwo.layer.borderColor = UIColor.blackColor().CGColor
                    Functions.loadImage(viewiPadLandscapeTwo!.imgViewTwo, urlImage: teams[numberOfRecordsToShow].shield!)
                    viewiPadLandscapeTwo!.lblNameViewTwo.text = teams[numberOfRecordsToShow].name!
                    viewiPadLandscapeTwo!.lblNumberPositionViewTwo.text = String(teams[numberOfRecordsToShow].position!)
                    viewiPadLandscapeTwo!.lblPointsViewTwo.text = String(teams[numberOfRecordsToShow].results!.points!)
                    numberOfRecordsToShow = numberOfRecordsToShow + 1
                    numberOfRecords = numberOfRecords - 1
                    
                }
                
                if (numberOfRecords == 0) {
                    viewiPadLandscapeTwo!.viewThree.hidden = true
                } else {
                    
                    viewiPadLandscapeTwo!.viewThree.layer.borderWidth = 1
                    viewiPadLandscapeTwo!.viewThree.layer.borderColor = UIColor.blackColor().CGColor
                    Functions.loadImage(viewiPadLandscapeTwo!.imgViewThree, urlImage: teams[numberOfRecordsToShow].shield!)
                    viewiPadLandscapeTwo!.lblNameViewThree.text = teams[numberOfRecordsToShow].name!
                    viewiPadLandscapeTwo!.lblNumberPositionViewThree.text = String(teams[numberOfRecordsToShow].position!)
                    viewiPadLandscapeTwo!.lblPointsViewThree.text = String(teams[numberOfRecordsToShow].results!.points!)
                    numberOfRecordsToShow = numberOfRecordsToShow + 1
                    numberOfRecords = numberOfRecords - 1
                    
                }
                
                selectedView = true
                viewiPadLandscape = viewiPadLandscapeTwo!
                
            }
            
            viewiPadLandscape.addConstraint(NSLayoutConstraint(
                item: viewiPadLandscape,
                attribute: NSLayoutAttribute.Height,
                relatedBy: NSLayoutRelation.Equal,
                toItem: viewiPadLandscape,
                attribute: NSLayoutAttribute.Height,
                multiplier: 0,
                constant: 150))
            viewiPadLandscape.translatesAutoresizingMaskIntoConstraints = false
            
            self.scrollView.addSubview(viewiPadLandscape)
            
            if (index == 1) {
                constraints.append(NSLayoutConstraint(
                    item: viewiPadLandscape,
                    attribute: NSLayoutAttribute.CenterX,
                    relatedBy: NSLayoutRelation.Equal,
                    toItem: self.scrollView,
                    attribute: NSLayoutAttribute.CenterX,
                    multiplier: 1,
                    constant: 0))
            }
            
            constraints.append(NSLayoutConstraint(
                item: self.scrollView,
                attribute: NSLayoutAttribute.Trailing,
                relatedBy: NSLayoutRelation.Equal,
                toItem: viewiPadLandscape,
                attribute: NSLayoutAttribute.Trailing,
                multiplier: 1,
                constant: 10))
            
            constraints.append(NSLayoutConstraint(
                item: viewiPadLandscape,
                attribute: NSLayoutAttribute.Leading,
                relatedBy: NSLayoutRelation.Equal,
                toItem: self.scrollView,
                attribute: NSLayoutAttribute.Leading,
                multiplier: 1,
                constant: 10))
            
            constraints.append(NSLayoutConstraint(
                item: viewiPadLandscape,
                attribute: NSLayoutAttribute.Top,
                relatedBy: NSLayoutRelation.Equal,
                toItem: self.scrollView,
                attribute: NSLayoutAttribute.Top,
                multiplier: 1,
                constant: yPosition))
            
            if (index == iterator) {
                constraints.append(NSLayoutConstraint(
                    item: self.scrollView,
                    attribute: NSLayoutAttribute.Bottom,
                    relatedBy: NSLayoutRelation.Equal,
                    toItem: viewiPadLandscape,
                    attribute: NSLayoutAttribute.Bottom,
                    multiplier: 1,
                    constant: 10))
            }
            
            self.scrollView.addConstraints(constraints)
            
            yPosition += 150 + 5
            
        }
        
    }
    
}
