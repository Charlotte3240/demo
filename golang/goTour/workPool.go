package main

import "fmt"

func main() {
	jobs := make(chan int, 100)
	result := make(chan int, 100)

	for i := 0; i < 3; i++ {
		go worker(i, jobs, result)
	}

	// 加入5个job
	for i := 0; i < 5; i++ {
		jobs <- i
	}
	close(jobs)

	// 读取result
	for {
		res := <- result
		fmt.Println(res)
		if len(result) == 0{
			break
		}
	}
	close(result)

}

func worker(id int, jobs <-chan int, result chan<- int) {
	for value := range jobs {
		fmt.Println(id, value)
		result <- value * 2
	}
}
