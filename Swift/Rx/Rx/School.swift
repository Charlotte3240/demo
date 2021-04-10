//
//  School.swift
//  Rx
//
//  Created by Charlotte on 2020/12/25.
//

import Foundation

class School: NSObject {
    
    var allStu : [Student] = [Student]()
    
    override init() {
        super.init()
        
        // all student
        let allStudent = getAllStudent()

        
        // grade == 3 && class == 3
        let grade5Class3Stu = allStudent.filter({s in return (s.grade == 3 && s.class == 3)})
        // get all male , do sth
        grade5Class3Stu
            .filter({$0.sex == .male})
            .forEach({$0.singASong()})
        let _ =  grade5Class3Stu
            .filter({$0.score! > 90})
            .map({$0.parent?.receiveAPrize()})
        
        grade5Class3Stu.filter({$0.score! < 90})
            .forEach({$0.singASong(songName: "我有罪")})
        
        // print class 3 , grade 2 , sort by score, des
        grade5Class3Stu.sorted { (s1, s2) -> Bool in
            s1.score! > s2.score!
        }.forEach({
            print($0.parent?.name! as Any,$0.score! as Any)
        })
            
    }
    
    func getAllStudent() -> [Student]{
        if allStu.count == 0{
            return generateStudent()
        }else{
            return allStu
        }
    }
    
    func generateStudent() -> [Student]{
        
        for index in 1...100 {
            let stuid = UUID.init().uuidString
            let parent = Parent.init(name: "\(index)号 parenrt", childId: stuid)
            let stu = Student(stuId: stuid, name: "\(index)号", score: Double(arc4random()%100), parent: parent, grade: Int(arc4random())%5,class: Int(arc4random()%5),sex: index%2==0 ? .male : .female)
            self.allStu.append(stu)
        }
        return self.allStu
    }
    
}
