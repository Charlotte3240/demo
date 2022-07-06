package main

import (
	"bytes"
	"fmt"
	"os"
	"os/exec"
)

func main() {
	Exec("touch aa.md")
}

func Exec(command string) error {
	in := bytes.NewBuffer(nil)
	cmd := exec.Command("sh")
	cmd.Stdin = in
	in.WriteString(command)
	if err := cmd.Run(); err != nil {
		fmt.Println(err.Error())
		os.Exit(1)
		return err
	}
	return nil
}
