// --------------------------------------------------------------------------------
// MIT License
//
// Copyright (c) 2019 Jens Kallup
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
// --------------------------------------------------------------------------------
#ifndef COMMON_H
#define COMMON_H
#pragma once

#include <iostream>

// ansi color codes
namespace ASCII {
    //Regular text
    const std::string BLK("\e[0;30m");
    const std::string RED("\e[0;31m");
    const std::string GRN("\e[0;32m");
    const std::string YEL("\e[0;33m");
    const std::string BLU("\e[0;34m");
    const std::string MAG("\e[0;35m");
    const std::string CYN("\e[0;36m");
    const std::string WHT("\e[0;37m");

    //Regular bold text
    const std::string BBLK("\e[1;30m");
    const std::string BRED("\e[1;31m");
    const std::string BGRN("\e[1;32m");
    const std::string BYEL("\e[1;33m");
    const std::string BBLU("\e[1;34m");
    const std::string BMAG("\e[1;35m");
    const std::string BCYN("\e[1;36m");
    const std::string BWHT("\e[1;37m");

    //Regular underline text
    const std::string UBLK("\e[4;30m");
    const std::string URED("\e[4;31m");
    const std::string UGRN("\e[4;32m");
    const std::string UYEL("\e[4;33m");
    const std::string UBLU("\e[4;34m");
    const std::string UMAG("\e[4;35m");
    const std::string UCYN("\e[4;36m");
    const std::string UWHT("\e[4;37m");

    //Regular background
    const std::string BLKB("\e[40m");
    const std::string REDB("\e[41m");
    const std::string GRNB("\e[42m");
    const std::string YELB("\e[43m");
    const std::string BLUB("\e[44m");
    const std::string MAGB("\e[45m");
    const std::string CYNB("\e[46m");
    const std::string WHTB("\e[47m");

    //High intensty background 
    const std::string BLKHB("\e[0;100m");
    const std::string REDHB("\e[0;101m");
    const std::string GRNHB("\e[0;102m");
    const std::string YELHB("\e[0;103m");
    const std::string BLUHB("\e[0;104m");
    const std::string MAGHB("\e[0;105m");
    const std::string CYNHB("\e[0;106m");
    const std::string WHTHB("\e[0;107m");

    //High intensty text
    const std::string HBLK("\e[0;90m");
    const std::string HRED("\e[0;91m");
    const std::string HGRN("\e[0;92m");
    const std::string HYEL("\e[0;93m");
    const std::string HBLU("\e[0;94m");
    const std::string HMAG("\e[0;95m");
    const std::string HCYN("\e[0;96m");
    const std::string HWHT("\e[0;97m");

    //Bold high intensity text
    const std::string BHBLK("\e[1;90m");
    const std::string BHRED("\e[1;91m");
    const std::string BHGRN("\e[1;92m");
    const std::string BHYEL("\e[1;93m");
    const std::string BHBLU("\e[1;94m");
    const std::string BHMAG("\e[1;95m");
    const std::string BHCYN("\e[1;96m");
    const std::string BHWHT("\e[1;97m");
}

#endif
