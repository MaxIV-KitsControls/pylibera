all: build

build:
	@echo "Building pyLibera interface"
	python setup.py build_ext --inplace

clean:
	rm -rf build/ 
	rm src/pylibera.cpp
	rm pylibera.so
	
deb:
	dpkg-buildpackage -us -uc

.PHONY: all clean deb