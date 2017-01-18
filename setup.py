from distutils.core import setup, Extension
from Cython.Build import cythonize

extensions = [
	Extension('pylibera', ['pylibera.pyx'], 
		include_dirs = ['/usr/include/libera-2.9'],
		extra_compile_args=["-std=c++0x"],
		language="c++",
		library_dirs=["/opt/libera/lib"],
		libraries=['liberaistd2.9','liberamci2.9', 'liberaisig2.9', 'liberainet2.9'])
	]

setup(
    ext_modules = cythonize(extensions)
)