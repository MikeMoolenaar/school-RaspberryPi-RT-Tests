apt-get install -y git build-essential
git clone git://git.kernel.org/pub/scm/utils/rt-tests/rt-tests.git
cd rt-tests
git checkout stable/v1.0
make all -j4
make install

cyclictest --mlockall --smp --priority=80 --interval=200 --distance=0 -l100000