# CIS_Server_Config_Scripts
Scripts for Server Configuration Review assessments for Ubuntu 20.04 and Ubuntu 22.04.

The script generates result2004.csv and result2204.csv files for 20.04 and 22.04 versions respectively.

Similarly the script will also generate output2004.txt and output2204.txt.

The `.csv` file would contain the testcase, status(result) of the testcase (PASS, FAIL, PENDING) and some details about the result.

The `.txt` file would contain output of all the commands executed with the testcases. For the PENDING testcases, we have to manually verify the result using output in `.txt` file.

Commands:
- When running as root user
```
./CIS_Config_Script_Ubuntu_20.04.sh | tee output2004.txt
./CIS_Config_Script_Ubuntu_22.04.sh | tee output2204.txt
```
- When not running as root user
```
sudo bash CIS_Config_Script_Ubuntu_20.04.sh | tee output2004.txt
sudo bash CIS_Config_Script_Ubuntu_22.04.sh | tee output2204.txt
```
