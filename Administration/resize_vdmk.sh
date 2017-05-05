"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" clonemedium "C:\Users\joaor\VirtualBox VMs\DSpaceVagrant_default_1493144378220_4048\ubuntu-xenial-16.04-cloudimg.vmdk" "C:\Users\joaor\VirtualBox VMs\DSpaceVagrant_default_1493144378220_4048\ubuntu-xenial-16.04-cloudimg.vdi" --format vdi
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" modifymedium "C:\Users\joaor\VirtualBox VMs\DSpaceVagrant_default_1493144378220_4048\ubuntu-xenial-16.04-cloudimg.vdi" --resize 51200
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" clonemedium "C:\Users\joaor\VirtualBox VMs\DSpaceVagrant_default_1493144378220_4048\ubuntu-xenial-16.04-cloudimg.vdi" "C:\Users\joaor\VirtualBox VMs\DSpaceVagrant_default_1493144378220_4048\ubuntu-xenial-16.04-cloudimg.vdmk" --format vmdk

cd ~/VirtualBox VMs/<vm_name> #change this
VBoxManage clonehd ubuntu-xenial-16.04-cloudimg.vmdk ubuntu-xenial-16.04-cloudimg.vdi --format vdi
VBoxManage modifyhd ubuntu-xenial-16.04-cloudimg.vdi --resize 51200 #for 50GB HD
mv ubuntu-xenial-16.04-cloudimg.vmdk ubuntu-xenial-16.04-cloudimg.vmdk.bak 
VBoxManage clonehd ubuntu-xenial-16.04-cloudimg.vdi ubuntu-xenial-16.04-cloudimg.vmdk --format vmdk
VBoxManage internalcommands sethduuid ubuntu-xenial-16.04-cloudimg.vmdk
#replace the given uuid in the storage section of the .vbox file

#<MediaRegistry>
#      <HardDisks>
#        <HardDisk uuid="{0079b17b-b6fa-43a4-88ae-2a731b58b210}" location="ubuntu-xenial-16.04-cloudimg-configdrive.vmdk" format="VMDK" type="Normal"/>
#        <HardDisk uuid="{a74087d2-8e96-4ef8-bb34-36775d89dcf3}" location="ubuntu-xenial-16.04-cloudimg.vmdk" format="VMDK" type="Normal"/>
#      </HardDisks>
#</MediaRegistry>

#Remove the vmdk hard drive in the VBox UI and reattach it again.
#Boot up!


rm -rf ubuntu-xenial-16.04-cloudimg.vmdk.bak #AFTER you check the clone was SUCCESSFUL!!!