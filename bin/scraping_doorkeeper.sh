#!/bin/sh                                                                                                                                                                    

export LANG=ja_JP.UTF-8

cd /home/moriyama/comon/
/usr/local/rbenv/shims/rails runner -e development 'Batch::Doorkeeper.get_events'
/usr/local/rbenv/shims/rails runner -e development 'Batch::Doorkeeper.get_participants'

time
