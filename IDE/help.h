#ifndef HELP_H
#define HELP_H

#include <cstddef> // NULL
#include <iomanip>
#include <iostream>
#include <ostream>
#include <istream>
#include <fstream>

#include "boost/archive/tmpdir.hpp"

#include "boost/archive/basic_archive.hpp"
#include "boost/archive/detail/basic_oserializer.hpp"
#include "boost/archive/binary_oarchive.hpp"
#include "boost/archive/binary_iarchive.hpp"

#include "boost/serialization/base_object.hpp"
#include "boost/serialization/string.hpp"
#include "boost/serialization/utility.hpp"
#include "boost/serialization/list.hpp"
#include "boost/serialization/assume_abstract.hpp"

class help_topic {
public:
    int         topic_idx;

    int         topic_len_str;
    int         topic_len_txt;

    std::string topic_str;
    std::string topic_txt;

    friend class boost::serialization::access;
    template<class Archive>
    void serialize(Archive & ar, const unsigned int version)
    {
        ar & topic_idx;

        ar & topic_str;
        ar & topic_txt;

        ar & topic_len_str;
        ar & topic_len_txt;
    }

    friend std::ostream & operator << (std::ostream &os, const help_topic &top)
    {
        os << top.topic_idx;

        os << top.topic_len_str;
        os << top.topic_len_txt;

        os.write(top.topic_str.c_str(),top.topic_str.size());
        os.write(top.topic_txt.c_str(),top.topic_txt.size());

        return os;
    }

    friend std::ifstream & operator >> (std::ifstream &in, const help_topic &top)
    {
        in.read(reinterpret_cast<char*>(top.topic_idx),sizeof(int));

        in.read(reinterpret_cast<char*>(top.topic_len_str),sizeof(int));
        in.read(reinterpret_cast<char*>(top.topic_len_txt),sizeof(int));

        in.read((char*)top.topic_str.c_str(),top.topic_str.size());
        in.read((char*)top.topic_txt.c_str(),top.topic_txt.size());
    }
public:
    help_topic() {}
};

class help_header {
public:
    ushort      file_type;
    int         version_;
    std::string password;
    int         password_len;
    int         entry_point;
    int         topics_no;

    friend class boost::serialization::access;
    template<class Archive>
    void serialize(Archive & ar, const unsigned int version)
    {
        ar & file_type;
        ar & version_;
        ar & entry_point;
        ar & password_len;
        ar & password;
        ar & topics_no;
    }

    friend std::ostream & operator << (std::ostream &os, const help_header &hdr)
    {
        os << hdr.file_type;
        os << hdr.version_;
        os << hdr.entry_point;
        os << hdr.password_len;
        os << hdr.password;
        os << hdr.topics_no;

        return os;
    }

    friend std::ifstream & operator >> (std::ifstream &in, const help_header &hdr)
    {
        in.read(reinterpret_cast<char*>(hdr.file_type),    sizeof(int));
        in.read(reinterpret_cast<char*>(hdr.version_),     sizeof(int));
        in.read(reinterpret_cast<char*>(hdr.entry_point),  sizeof(int));
        in.read(reinterpret_cast<char*>(hdr.password_len), sizeof(int));
        in.read((char*)hdr.password.c_str(),hdr.password.size());

        in.read(reinterpret_cast<char*>(hdr.topics_no), sizeof(int));
    }
public:
    help_header() {}
};

#endif // HELP_H
