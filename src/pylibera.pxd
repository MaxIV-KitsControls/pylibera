from libcpp.string cimport string
from libcpp.vector cimport vector as std_vector

cdef extern from "pyliberaclient.h" namespace "pyLibera":
    cdef cppclass pyLiberaClient:
        pyLiberaClient(string, string) except +
        init()
        double GetValue(string) except +
        std_vector[string] MagicCommand(string) except +
        # getDataFrameValues(node) except +
