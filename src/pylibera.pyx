# distutils: language = c++
# distutils: sources = src/pyliberaclient.cpp

from pylibera cimport pyLiberaClient
from libcpp.string cimport string as std_string
from libcpp.vector cimport vector as std_vector
from collections import defaultdict
import pandas

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

    def MagicCommand(PyLiberaClient self, node):
  	#Main Walk Tree node method
      self._check_alive()
      return self._thisptr.MagicCommand(node)


    def GetValues(PyLiberaClient self, node):
    	#Main Get node value method
        self._check_alive()
        values = self._thisptr.GetValue(node)
        # Clean the list from the lines which they are just parents
        #i.e "boards,raf3,conditioning,coefficients,channel_2,gain,pattern_1"
        return [value for value in values if "=" in value]

    # #Get Values and return a DataFrame with Nodes,Values Column
    # def getDataFrameValues(PyLiberaClient self, node):
    #     #Get values in a list "boards,raf3,conditioning,coefficients,channel_2,gain,pattern_1=1"
    #     values = self.MagicCommand(node)
    #     #return pandas.DataFrame(df.row.str.split(' ',1).tolist(), columns = ['nodes','values'])





    # def getTreeValues(PyLiberaClient self, node):
    #     #define of tree object
    #     #mci_tree = Tree()
    #     #https://gist.github.com/hrldcpr/2012250
    #     mci_tree = makehash()
    #     #Get values in a list "boards,raf3,conditioning,coefficients,channel_2,gain,pattern_1=1"
    #     values = self.MagicCommand(node)
    #
    #     #convert each like to a dict hierarcy i.e
    #     # from boards,raf3,conditioning,coefficients,channel_2,gain,pattern_1=1
    #     # to tree['boards']['raf3']['conditioning']['coefficients']['channel_2']['gain,pattern_1'] = 1"
    #     # for leaf in values:
    #     #     if "=" in leaf:
    #     #         #replace  = with ','
    #     #         leaf = leaf.replace("=",",")
    #     #         print(leaf)
    #     #         #line_split = leaf.split("=")
    #     #         node_list = leaf.split(",")
    #     #         for node in node_list:
    #     #             mci_tree = mci_tree[node]
    #     #             #print node, line_split[1]
    #     #         #mci_tree = line_split[1]
    #     for leaf in values:
    #         if "=" in leaf:
    #             #replace  = with ','
    #             leaf = leaf.replace("=",",")
    #             #nodes = [ i.split(',').strip() for i in leaf]
    #             nodes = leaf.split(',')
    #
    #             #t = Tree()
    #
    #             #print nodes
    #
    #             for node in nodes:
    #                 #print node
    #                 add(mci_tree, node)
    #
    #     #print(dict(mci_tree))
    #
    #     return mci_tree
          #print(mci_tree, node_list[-1], line_split[1])


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
