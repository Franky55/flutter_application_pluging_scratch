// CPU_Usage_Reddit.cpp : This file contains the 'main' function. Program execution begins and ends there.
//

#include "windows.h"
#include <iostream>
#include <string>
#include <iomanip>
#include <vector>

#pragma comment(lib,"pdh.lib")
#include "TCHAR.h"
#include "pdh.h"

using namespace std;

//this is not the code but i will have to check it out
//https://stackoverflow.com/questions/12164125/c-c-system-and-programs-resource-monitoring-windows


static PDH_HQUERY cpuQuery;
static PDH_HCOUNTER cpuTotal;

void initialize() 
{
    PdhOpenQuery(NULL, NULL, &cpuQuery);
    // You can also use L"\\Processor(*)\\% Processor Time" and get individual CPU values with PdhGetFormattedCounterArray()
    PdhAddEnglishCounter(cpuQuery, "\\Processor(_Total)\\% Processor Time", NULL, &cpuTotal);
    PdhCollectQueryData(cpuQuery);
}

float getCurrentValue() 
{
    PDH_FMT_COUNTERVALUE counterVal;

    PdhCollectQueryData(cpuQuery);
    PdhGetFormattedCounterValue(cpuTotal, PDH_FMT_DOUBLE, NULL, &counterVal);
    return float(counterVal.doubleValue);
}


int getAverage()
{
    static float vals[10];

    for (int i = 0; i < 9; i++)
    {
        vals[i] = vals[i + 1];
    }

    vals[9] = getCurrentValue();
    float val = 0;

    for (int i = 0; i < 10; i++)
    {
        val += vals[i];
    }


    return (int)(val / 10);

}

int main()
{
    //printf("CPU: %u", getAverage_CPU());
    cout << "Hello World!\n";
    

    float vals[10];

    //val.StartResourceMonitor();

    initialize();

    while (1)
    {
        for (int i = 0; i < 9; i++)
        {
            vals[i] = vals[i + 1];
        }

        vals[9] = getCurrentValue();
        float val = 0;

        for (int i = 0; i < 10; i++)
        {
            val += vals[i];
        }

        cout << "CPU%: " << (int)(val / 10) << endl;
        Sleep(100);
    }
    
    return 0;
}



