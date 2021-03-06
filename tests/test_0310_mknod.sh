#!/bin/sh
#
# NFS servers generally want us to be root in order to create device nodes.
# We can lie and impersonate root by setting uid=0 in the URL.

. ./functions.sh

echo "basic mknod test"

start_share

mkdir "${TESTDIR}/subdir"
mkdir "${TESTDIR}/subdir2"

echo -n "Create a chrdev in the root (abs) (1)... "
./prog_mknod "${TESTURL}/?uid=0" "." /mknod1 020755 0x1234 || failure
success

echo -n "Stat the node ... "
./prog_stat "${TESTURL}/" "." mknod1 > "${TESTDIR}/output" || failure
success

echo -n "Testing nfs_mode and verify it is a CHRDEV ... "
grep "nfs_mode:20755" "${TESTDIR}/output" >/dev/null || failure
success

echo -n "Create a chrdev in the root (rel) (2)... "
./prog_mknod "${TESTURL}/?uid=0" "." mknod2 020775 0x1234 || failure
success

echo -n "Create a chrdev in a subdirectory (abs) (3)... "
./prog_mknod "${TESTURL}/?uid=0" "." /subdir/mknod3 020775 0x1234 || failure
success

echo -n "Create a chrdev in a subdirectory (abs) (4)... "
./prog_mknod "${TESTURL}/?uid=0" "." subdir/mknod4 020775 0x1234 || failure
success

echo -n "Create a chrdev from a different cwd (abs) (5)... "
./prog_mknod "${TESTURL}/?uid=0" "subdir" ../subdir2/mknod5 020775 0x1234 || failure
success

echo -n "Create a chrdev outside the share (abs) (6)... "
./prog_mknod "${TESTURL}/?uid=0" "." ../subdir2/mknod6 020775 0x1234 2>/dev/null && failure
success

stop_share

exit 0
