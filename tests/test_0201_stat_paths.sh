#!/bin/sh

. ./functions.sh

echo "nfs_stat64() path tests"

start_share

mkdir "${TESTDIR}/subdir"
mkdir "${TESTDIR}/subdir2"

echo -n "Test nfs_stat64() for a root file (abs) (1)... "
touch "${TESTDIR}/stat1"
./prog_stat "${TESTURL}/" "." /stat1 >/dev/null || failure
success

echo -n "Test nfs_stat64() for a root file (rel) (2)... "
./prog_stat "${TESTURL}/" "." stat1 >/dev/null || failure
success

echo -n "Test nfs_stat64() for a subdir file (abs) (3)... "
touch "${TESTDIR}/subdir/stat3"
./prog_stat "${TESTURL}/" "." /subdir/stat3 >/dev/null || failure
success

echo -n "Test nfs_stat64() for a subdir file (rel) (4)... "
./prog_stat "${TESTURL}/" "." subdir/stat3 >/dev/null || failure
success

echo -n "Test nfs_stat64() from a different cwd (rel) (5)... "
./prog_stat "${TESTURL}/" "subdir2" ../subdir/stat3 >/dev/null || failure
success

echo -n "Test nfs_stat64() outside the share (rel) (6)... "
./prog_stat "${TESTURL}/" "subdir2" ../../subdir/stat3 >/dev/null 2>&1 && failure
success

stop_share

exit 0
