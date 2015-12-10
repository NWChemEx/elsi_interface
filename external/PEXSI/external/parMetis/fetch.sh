#!/bin/sh

package=parmetis-4.0.2.tar.gz

curl -O http://glaros.dtc.umn.edu/gkhome/fetch/sw/parmetis/$package
tar xvfz $package
mv parmetis*/* .
rm -rf parmetis* $package