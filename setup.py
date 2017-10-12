from distutils.core import setup, Extension
from Cython.Build import cythonize

api_version = str(3.2)
itech_libera_list = ['liberaistd','liberamci', 'liberaisig', 'liberainet']
extensions = [
	Extension('*', ['src/pylibera.pyx'], 
		include_dirs = ['/usr/include/libera-'+api_version],
		extra_compile_args=["-std=c++0x"],
		language="c++",
		library_dirs=["/opt/libera/lib"],
		libraries=[libr + api_version for libr in itech_libera_list])
	]

setup(
    ext_modules = cythonize(extensions)
)
