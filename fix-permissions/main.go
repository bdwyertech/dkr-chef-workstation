package main

import (
	"os"
	"os/exec"
	"strings"
)

func main() {
	runCommand("chown --silent chef:chef /chef/")
	runCommand("chown --silent -R chef /chef/.kitchen/ /chef/Berksfile /chef/Berksfile.lock")
}

func runCommand(command string) error {
	cmdFields := strings.Fields(command)
	cmdPath := cmdFields[0]
	cmdArgs := []string{}
	if len(cmdFields) > 1 {
		cmdArgs = cmdFields[1:]
	}
	cmd := exec.Command(cmdPath, cmdArgs...)
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	cmd.Stdin = os.Stdin
	return cmd.Run()
}
