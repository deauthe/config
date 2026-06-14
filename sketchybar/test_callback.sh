#!/bin/bash
echo "Test callback executed at $(date)" >> /tmp/aerospace_test.log
echo "AEROSPACE_FOCUSED_WORKSPACE=$AEROSPACE_FOCUSED_WORKSPACE" >> /tmp/aerospace_test.log
echo "AEROSPACE_PREV_WORKSPACE=$AEROSPACE_PREV_WORKSPACE" >> /tmp/aerospace_test.log
echo "All env vars:" >> /tmp/aerospace_test.log
env | grep AEROSPACE >> /tmp/aerospace_test.log
echo "---" >> /tmp/aerospace_test.log 