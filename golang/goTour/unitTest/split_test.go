package unitTest

import (
	"reflect"
	"strconv"
	"testing"
)

// TestSplit 命名必须以Test开头，传入的类型为 *testing.T
//func TestSplit(t *testing.T){
//	//got := Split("charlotte","l")
//	//want := []string{"char","otte"}
//
//	got := Split("我爱你","爱")
//	want := []string{"我","你"}
//
//	if reflect.DeepEqual(got,want) == false{
//		// 和期望结果不一致
//		fmt.Println("和期望结果不一致")
//		t.Errorf("want :%v got:%v \n",want,got)
//	}else {
//		fmt.Println("split test pass")
//	}
//
//}

func TestSplit(t *testing.T) {
	type test struct {
		input string
		sep   string
		want  []string
	}

	tests := []test{
		test{"charlotte", "l", []string{"char", "otte"}},
		test{"我爱你", "爱", []string{"我", "你"}},
		test{"zhinengfuwu", "n", []string{"zhi", "e", "gfuwu"}},
	}
	for index, value := range tests {
		t.Run("case"+strconv.Itoa(index), func(t *testing.T) {
			got := Split(value.input, value.sep)
			if reflect.DeepEqual(got, value.want) == false {
				t.Errorf("not pass got:%#v  want:%#v \n", got, value.want)
			}
		})
	}
	// commond line
	// go test
	// go test -v
	// go test -run=TestSplit/case0

	// 测试覆盖率
	// go test -cover
	// 输出文件
	// go test -cover -coverprofile=c.out
	// 以html形式打开 .out 文件
	// go tool cover -html=c.out

}


//MARK: - 性能基准测试
func BenchmarkSplit(b *testing.B) {
	// b.N 不是一个固定的数
	for i := 0; i < b.N; i++ {
		Split("charlotte","l")
	}
	// commond line
	// go test -bench=Split
	/*
		➜  unitTest git:(master) ✗ go test -bench=Split
		goos: darwin
		goarch: amd64
		pkg: testdemo
		cpu: Intel(R) Core(TM) i5-8257U CPU @ 1.40GHz
		(占用cpu 数量)		(运行次数)			(运行单次所需时间)
		BenchmarkSplit-8   	10373857	       113.6 ns/op
		PASS
		ok  	testdemo	1.303s
	*/
	// 拿到内存数据
	// go test -bench=Split -benchmem
	/*
		➜  unitTest git:(master) ✗ go test -bench=Split -benchmem
		goos: darwin
		goarch: amd64
		pkg: testdemo
		cpu: Intel(R) Core(TM) i5-8257U CPU @ 1.40GHz
		BenchmarkSplit-8   	10260708	       113.8 ns/op	      48 B/op（每次执行所需内存）	       2 allocs/op
		PASS
		ok  	testdemo	1.293s
	*/
}






func BenchmarkMd51(b *testing.B) {
	for i := 0; i < b.N; i++ {
		Md51()
	}
}

func BenchmarkMd52(b *testing.B) {
	for i := 0; i < b.N; i++ {
		Md52()
	}
}

func BenchmarkMd53(b *testing.B) {
	for i := 0; i < b.N; i++ {
		Md53()
	}
}