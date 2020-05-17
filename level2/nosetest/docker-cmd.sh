#!/bin/sh

/usr/local/bin/nosetests --with-allure --logdir=/app/allure-results --not-clear-logdir --nologcapture --nocapture --process-timeout=240 --process-restartworker --verbose $@