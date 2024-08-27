
#include <rbase/inc/cmdline.h>
#include <rbase/inc/console.h>
#include <rbase/inc/path.h>
#include <rbase/inc/file.h>

void help()
{
	rtm::Console::print(
		"Usage: bin2c -s <src> -d <dst> -v <var>\n"
		"\n"
		" args:\n"
		"  src:   Source binary file\n"
		"  dst:   Destination C/H file\n"
		"  var:   Variable name (optional)\n"
		"\n"
		"Options:\n"
		"  -h, -?, -help             Displays this help and exits.\n"
	);
	exit(0);
}

void error(const char* _message)
{
	rtm::Console::error(_message);
	exit(1);
}

static inline void writeString(rtm::FileWriterHandle _writer, const char* _str)
{
	rtm::fileWriterWrite(_writer, _str, rtm::strLen(_str));
}

static inline void writeCharacter(rtm::FileWriterHandle _writer, const char _c)
{
	rtm::fileWriterWrite(_writer, &_c, 1);
}

int main(int argc, char** argv)
{
	rtm::CommandLine cmd(argc, argv);

	if (cmd.hasArg('?') || cmd.hasArg('h', "help"))
		help();

	const char* arg_srcFile  = 0;
	const char* arg_dstFile  = 0;
	const char* arg_variable = 0;
	if (!cmd.getArg('s', arg_srcFile))
		error("Must specify source file, use bin2c -h for help");
	else
	{
		rtm::Console::print("Source file: ");
		rtm::Console::info("%s\n", arg_srcFile);
	}

	if (!cmd.getArg('d', arg_dstFile))
		error("Must specify destination file, use bin2c -h for help");
	else
	{
		rtm::Console::print("Destination file: ");
		rtm::Console::info("%s\n", arg_dstFile);
	}

	char varName[512];
	if (!cmd.getArg('v', arg_variable))
	{
		const char* srcFile	= rtm::pathGetFileName(arg_srcFile);
		const char* srcExt	= rtm::pathGetExt(srcFile);

		uintptr_t nameLen = srcExt - srcFile - 1;
		rtm::strlCpy(varName, 512, srcFile, (uint32_t)nameLen);
		varName[511] = '\0';
		nameLen = 1;
	}
	else
		rtm::strlCpy(varName, 512, arg_variable);


	uint8_t* fileBuffer	= 0;
	uint64_t fileSize	= 0;

	// read binary
	rtm::FileReaderHandle fileReader = rtm::fileReaderCreate(rtm::File::LocalStorage);
	if (rtm::isValid(fileReader))
	{
		fileSize = rtm::fileGetSize(rtm::File::LocalStorage, arg_srcFile);
		if (rtm::File::Open == rtm::fileReaderOpen(fileReader, arg_srcFile))
		{
			fileBuffer = new uint8_t[fileSize];
			rtm::fileReaderRead(fileReader, fileBuffer, fileSize);
			rtm::fileReaderClose(fileReader);
		}
	}

	// write C source
	rtm::FileWriterHandle fileWriter = rtm::fileWriterCreate(rtm::File::LocalStorage);
	if (rtm::isValid(fileWriter))
	{
		if (rtm::File::Open == rtm::fileWriterOpen(fileWriter, arg_dstFile))
		{
			char sizeBuffer[32];
			sprintf(sizeBuffer, "%d", (int)fileSize);
			writeString(fileWriter, "uint32_t ");
			writeString(fileWriter, varName);
			writeString(fileWriter, "_size = ");
			writeString(fileWriter, sizeBuffer);
			writeString(fileWriter, ";\n");

			writeString(fileWriter, "uint8_t ");
			writeString(fileWriter, varName);
			writeString(fileWriter, "[");
			writeString(fileWriter, sizeBuffer);
			writeString(fileWriter, "] = { \n\t");
			for (uint32_t i=0; i<fileSize; ++i)
			{
				const char c = fileBuffer[i];
				const char lo = rtm::toHexNum(c & 0xf);
				const char up = rtm::toHexNum((c >> 4)& 0xf);
				writeString(fileWriter, "0x");
				writeCharacter(fileWriter, up);
				writeCharacter(fileWriter, lo);
				if (i != fileSize - 1)
					writeString(fileWriter, ", ");

				if ((i+1) % 32 == 0)
					writeString(fileWriter, "\n\t");
			}
			writeString(fileWriter, "\n};\n");

			rtm::fileWriterClose(fileWriter);
		}
	}

	delete[] fileBuffer;
}
