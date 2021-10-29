package main

type Student struct {
	ID    int    `json:"id"`
	Name  string `json:"name"`
	Class string `json:"class"`
}

// 构造函数
func NewStudent(id int, name, class string) *Student {
	return &Student{id, name, class}
}

type StuManager struct {
	AllStus []*Student
}

func NewStuManager() *StuManager {
	return &StuManager{
		make([]*Student, 0, 100),
	}
}

func (s *StuManager) addStudent(stu Student) {
	s.AllStus = append(s.AllStus, &stu)
}

func (s *StuManager) delStudent(stu Student) {
	tempIndex := s.selectStudent(stu)
	if tempIndex == -1 {
		return
	}
	s.AllStus = append(s.AllStus[:tempIndex], s.AllStus[tempIndex+1:]...)
}

func (s *StuManager) alertStudent(stu Student) {
	tempIndex := s.selectStudent(stu)
	if tempIndex == -1 {
		return
	}
	s.AllStus[tempIndex] = &stu
}

// 返回当前的index
func (s *StuManager) selectStudent(stu Student) int {
	tempIndex := -1
	for i, stuEle := range s.AllStus {
		if stuEle.ID == stu.ID {
			tempIndex = i
		}
	}
	return tempIndex
}
