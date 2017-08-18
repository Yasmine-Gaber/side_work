#! /bin/bash
# check if rake is up
if ! `ps aux | grep processing:process_all | grep -v grep &> /dev/null`; then
  /bin/bash -l -c 'cd /var/www/sidework/ && bundle exec rake processing:process_all RAILS_ENV=production --trace &>> /var/www/sidework/log/processall-"$(date +%Y-%m-%d)".log &'
fi
