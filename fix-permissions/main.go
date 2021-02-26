package main

import (
	"log"
	"os"
	"os/exec"
	"strings"
)

func main() {
	runCommand("chown --silent chef:chef /chef/")
	runCommand("chown --silent -R chef /chef/.kitchen/ /chef/Berksfile /chef/Berksfile.lock")
	runCommand("find /chef/ ( ! -gid 1000 -or ( ! -perm -o=r ) ) -exec chgrp 1000 {} ; -exec chmod g+r {} ;")
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
