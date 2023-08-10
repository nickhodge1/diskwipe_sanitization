<h1>Disk Wipe - Disk Sanitization</h1>


<h2>Description</h2>
This project is a PowerShell script that "zeros out" (wipes) any drive that is selected from the prompt in the command. The utility allows a user to select the target disk and then choose the number of passes that are performed during the disk wipe. The PowerShell script will also run a diskpart script file based on the user's selections. Then the utility will launch Diskpart to perform disk sanitization. Finally, the disk will be formatted and primary partition set (ntfs permissions and drive letter assigned). I found this project on Josh Madakor's Youtube page, which I used to learn more about Powershell. I made some changes where needed and also some improvements which are detailed below:
<br>
<br>
<b>Initial Variables</b>
<br />


<h2>Languages and Utilities Used</h2>

- <b>PowerShell</b> 
- <b>Diskpart</b>

<h2>Environments Used </h2>

- <b>Windows 10</b> (21H2)
- <b>Windows 10</b> (22H2)
- <b>Windows 11</b> (22H2)

<h2>Program Screenshots:</h2>

<p align="center">
<b>Screenshot of J: drive containing data/pictures:</b> <br/>
<img src="https://imgur.com/RxXGjE9.png" height="80%" width="80%" alt="Disk Sanitization Steps"/>
<br />
<br />
<b>User input (select disk ID):</b> <br/>
<img src="https://imgur.com/LQCoLBc.png" height="80%" width="80%" alt="Disk Sanitization Steps"/>
<br />
<br />
<b>User input (enter number of passes for disk wipe):</b> <br/>
<img src="https://imgur.com/3vTKLMx.png" height="80%" width="80%" alt="Disk Sanitization Steps"/>
<br />
<br />
<b>User input (confirm disk ID and number of passes for disk wipe):</b>  <br/>
<img src="https://imgur.com/iUBechQ.png" height="80%" width="80%" alt="Disk Sanitization Steps"/>
<br />
<br />
<b>Disk 1 selected (sanitization in progress) this may take some time to complete:</b>  <br/>
<img src="https://imgur.com/EFaxDy2.png" height="80%" width="80%" alt="Disk Sanitization Steps"/>
<br />
<br />
<b>DiskPart succeeded in wiping the disk:</b>  <br/>
<img src="https://imgur.com/rNJO97I.png" height="80%" width="80%" alt="Disk Sanitization Steps"/>
<br />
<br />
<b>Disk format complete and primary partition set (ntfs permissions applied and drive letter assigned:</b>  <br/>
<img src="https://imgur.com/aFhSWME.png" height="80%" width="80%" alt="Disk Sanitization Steps"/>
<br />
<br />
<b>Drive J: shown after wipe containing no data:</b>  <br/>
<img src="https://imgur.com/jDWb5ZJ.png" height="80%" width="80%" alt="Disk Sanitization Steps"/>
<br />
<br />
</p>

<!--
 ```diff
- text in red
+ text in green
! text in orange
# text in gray
@@ text in purple (and bold)@@
```
--!>
