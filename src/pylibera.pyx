# distutils: language = c++
# distutils: sources = pyliberaclient.cpp

from pylibera cimport pyLiberaClient


cdef class PyLiberaClient:

    """
    Cython wrapper class for C++ Libera
    """

    cdef:
        pyLiberaClient *_thisptr
        string _ip
        string _root_type

    def __cinit__(PyLiberaClient self):
        self._thisptr = NULL

    def __init__(PyLiberaClient self, ip="127.0.0.1", root_type="application"):
        self._ip = ip
        self._root_type=root_type
        self._thisptr = new pyLiberaClient(self._ip, self._root_type)
    
    #experimental for reset the connection
    def init(PyLiberaClient self):
        #backup settings
        ip = self._ip
        ip = self._root_type
        #remove old object
        self.__exit__(None, None, None)
        #create again same object
        self._thisptr = new pyLiberaClient(self._ip, self._root_type)
    
    def __dealloc__(PyLiberaClient self):
        # Only call del if the C++ object is alive,
        # or we will get a segfault.
        if self._thisptr != NULL:
            del self._thisptr


    cdef int _check_alive(PyLiberaClient self) except -1:
        # Beacuse of the context manager protocol, the C++ object
        # might die before PyLiberaClient self is reclaimed.
        # We therefore need a small utility to check for the
        # availability of self._thisptr
        if self._thisptr == NULL:
            raise RuntimeError("Wrapped C++ object is deleted")
        else:
            return 0
	
    def GetValue(PyLiberaClient self, node):
    	#Main Get node value method
        self._check_alive()
        return self._thisptr.GetValue(node)


    # The context manager protocol allows us to precisely
    # control the liftetime of the wrapped C++ object. del
    # is called deterministically and independently of
    # the Python garbage collection.

    def __enter__(PyLiberaClient self):
        self._check_alive()
        return self

    def __exit__(PyLiberaClient self, exc_tp, exc_val, exc_tb):
        if self._thisptr != NULL:
            del self._thisptr
            self._thisptr = NULL # inform __dealloc__
        return False # propagate exceptions
