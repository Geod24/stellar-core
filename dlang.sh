make -C src/scp && make -j7 check LDFLAGS="-L/usr/lib/ -lphobos2 -L/home/geod24/projects/stellar-core/src/scp/ -lscp"
