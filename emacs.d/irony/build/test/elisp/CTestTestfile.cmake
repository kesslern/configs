# CMake generated Testfile for 
# Source directory: /home/nathan/.emacs.d/elpa/irony-0.1.1/server/test/elisp
# Build directory: /home/nathan/.emacs.d/irony/build/test/elisp
# 
# This file includes the relevant testing commands required for 
# testing this directory and lists subdirectories to be tested as well.
add_test(irony-el "/usr/sbin/emacs" "-batch" "-l" "package" "--eval" "(package-initialize) (unless (require 'cl-lib nil t) (package-refresh-contents) (package-install 'cl-lib))" "-l" "/home/nathan/.emacs.d/elpa/irony-0.1.1/server/test/elisp/irony.el" "-f" "ert-run-tests-batch-and-exit")
add_test(irony-cdb-el "/usr/sbin/emacs" "-batch" "-l" "package" "--eval" "(package-initialize) (unless (require 'cl-lib nil t) (package-refresh-contents) (package-install 'cl-lib))" "-l" "/home/nathan/.emacs.d/elpa/irony-0.1.1/server/test/elisp/irony-cdb.el" "-f" "ert-run-tests-batch-and-exit")