// --------------------------------------------------------------------------------
// MIT License
//
// Copyright (c) 2018 Jens Kallup
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
#ifndef IDENTITY_T_H
#define IDENTITY_T_H
#pragma once

#include <stdio.h>
#include <stdlib.h>
#include <strings.h>

#include <iostream>
#include <string>
#include <sstream>

#include <vector>

#include "data.h"
#include "misc.h"

class forth_identity_t
{
public:
    std::string       id;
    std::stringstream id_stream;
    FILE *            id_file;

    std::vector<forth_routines_t > forth_routines;
    std::vector<forth_variables_t> forth_variables;
    std::vector<forth_labels_t   > forth_labels;
    std::vector<forth_codes_t    > forth_codes;

    void add(forth_routines_t  && data) { forth_routines .push_back(std::forward<decltype(data)>(data)); }
    void add(forth_variables_t && data) { forth_variables.push_back(std::forward<decltype(data)>(data)); }
    void add(forth_labels_t    && data) { forth_labels   .push_back(std::forward<decltype(data)>(data)); }
    void add(forth_codes_t     && data) { forth_codes    .push_back(std::forward<decltype(data)>(data)); }
};
#endif
