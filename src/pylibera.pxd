from libcpp.string cimport string

cdef extern from "pyliberaclient.h" namespace "pyLibera":
    cdef cppclass pyLiberaClient:
        pyLiberaClient(string, string) except +
        init()
        double GetValue(string) except +