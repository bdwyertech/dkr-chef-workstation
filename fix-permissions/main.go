package main

import (
	"fmt"
	"log"
	"os"
	"os/exec"
	"strings"
)

func main() {
	if len(os.Args) > 2 && strings.EqualFold(os.Args[1], "id") {
		runCommand(fmt.Sprintf("groupmod chef --gid %s", os.Args[2]))
		runCommand(fmt.Sprintf("usermod chef --uid %[1]s --gid %[1]s --groups root", os.Args[2]))
		runCommand("chown --silent -R chef:chef /home/chef/")
	} else {
		runCommand("chown --silent chef:chef /chef/")
		runCommand("chown --silent -R chef /chef/.kitchen/ /chef/Berksfile /chef/Berksfile.lock")
		runCommand("find /chef/ ( ! -gid 1000 -or ( ! -perm -o=r ) ) -exec chgrp 1000 {} ; -exec chmod g+r {} ;")
	}
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
	log.Println(cmd.String())
	return cmd.Run()
}
