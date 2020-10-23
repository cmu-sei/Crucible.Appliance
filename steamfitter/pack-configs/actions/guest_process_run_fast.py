# Crucible
# Copyright 2020 Carnegie Mellon University.
# NO WARRANTY. THIS CARNEGIE MELLON UNIVERSITY AND SOFTWARE ENGINEERING INSTITUTE MATERIAL IS FURNISHED ON AN "AS-IS" BASIS. CARNEGIE MELLON UNIVERSITY MAKES NO WARRANTIES OF ANY KIND, EITHER EXPRESSED OR IMPLIED, AS TO ANY MATTER INCLUDING, BUT NOT LIMITED TO, WARRANTY OF FITNESS FOR PURPOSE OR MERCHANTABILITY, EXCLUSIVITY, OR RESULTS OBTAINED FROM USE OF THE MATERIAL. CARNEGIE MELLON UNIVERSITY DOES NOT MAKE ANY WARRANTY OF ANY KIND WITH RESPECT TO FREEDOM FROM PATENT, TRADEMARK, OR COPYRIGHT INFRINGEMENT.
# Released under a MIT (SEI)-style license, please see license.txt or contact permission@sei.cmu.edu for full terms.
# [DISTRIBUTION STATEMENT A] This material has been approved for public release and unlimited distribution.  Please see Copyright notice for non-US Government use and distribution.
# Carnegie Mellon(R) and CERT(R) are registered in the U.S. Patent and Trademark Office by Carnegie Mellon University.
# DM20-0181

from vmwarelib.guest import GuestAction
from pyVmomi import vim  # pylint: disable-msg=E0611
import eventlet
import os
import requests
import sys


class StartProgramInGuest(GuestAction):

    def run(self, vm_id, username, password, command, arguments, workdir,
            envvar, vsphere=None):
        """
        Execute a program inside a guest using Python script only.

        Args:
        - vm_id: MOID of the Virtual Machine
        - username: username to perform the operation
        - password: password of that user
        - command: command to run
        - arguments: [optional] command argument(s)
        - workdir: [optional] working directory
        - envvar: [optional] [array] environment variable(s)
        - vsphere: Pre-configured vsphere connection details (config.yaml)
        """
        self.prepare_guest_operation(vsphere, vm_id, username, password)
        cmdargs = arguments
        if not cmdargs:
            cmdargs = ''
        else:
            cmdargs = cmdargs + ' 1>stdout 2>stderr'
        if not workdir:
            workdir = self.guest_file_manager.CreateTemporaryDirectoryInGuest(
            self.vm, self.guest_credentials, "crucible_", "_dir")

        cmdspec = vim.vm.guest.ProcessManager.ProgramSpec(
            arguments=cmdargs,
            envVariables=envvar,
            programPath=command,
            workingDirectory=workdir)
        print(cmdspec)
        pid = self.guest_process_manager.StartProgramInGuest(
            self.vm, self.guest_credentials, cmdspec)
        delay = 1
        max_delay = 8
        exit_code = 0
        still_waiting = True
        output_path = self.joinpath(workdir, "stdout")
        other_path = self.joinpath(workdir, "stderr")
        while still_waiting:
            inf = self.guest_process_manager.ListProcessesInGuest(
                vm=self.vm, auth=self.guest_credentials, pids=[pid])
            if not inf:
                raise Exception("No such process: " + str(pid))
            elif inf[0].endTime is not None:
                exit_code = inf[0].exitCode
                still_waiting = False
            else:
                eventlet.sleep(delay)
                delay = min(delay * 2, max_delay)
        if exit_code != 0:
            temp_path = output_path
            output_path = other_path
            other_path = temp_path
        dl_url = self.guest_file_manager.InitiateFileTransferFromGuest(
            self.vm, self.guest_credentials, guestFilePath=output_path)
        response = requests.get(dl_url.url, verify=False)

        self.guest_file_manager.DeleteDirectoryInGuest(
            self.vm, self.guest_credentials, workdir, True)

        response.raise_for_status()  # raise if status_code not 200
        return response.text
