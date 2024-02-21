#include "device_id.h"
#include <stdlib.h>
#include <stdio.h>
#include "md5.h"

#define BUF_SIZE 1024  

std::string getProcessorid() {
	FILE* p_file = NULL;
	char buf[BUF_SIZE];

	std::string ret;

	p_file = _popen("wmic cpu get processorid", "r");
	if (!p_file) {
		return ret;
	}

	while (fgets(buf, BUF_SIZE, p_file) != NULL) {
		ret.append(buf);
	}
	_pclose(p_file);
	return ret;
}

std::string GetBaseboard() {
	FILE* p_file = NULL;
	char buf[BUF_SIZE];

	std::string ret;

	p_file = _popen("wmic csproduct get UUID", "r");
	if (!p_file) {
		return ret;
	}

	while (fgets(buf, BUF_SIZE, p_file) != NULL) {
		ret.append(buf);
	}
	_pclose(p_file);
	return ret;
}


std::string GetDiskdrive() {
	FILE* p_file = NULL;
	char buf[BUF_SIZE];

	std::string ret;

	p_file = _popen("wmic diskdrive where index=0 get serialnumber", "r");
	if (!p_file) {
		return ret;
	}

	while (fgets(buf, BUF_SIZE, p_file) != NULL) {
		ret.append(buf);
	}
	_pclose(p_file);
	return ret;
}


const std::wstring getDeviceID()
{
	std::string cpuId = getProcessorid();
	std::string baseId = GetBaseboard();
	std::string diskId = GetDiskdrive();
	
	std::string text;
	text.append(cpuId);
	text.append(baseId);
	text.append(diskId);

	return  MD5(text).toStr();
}


