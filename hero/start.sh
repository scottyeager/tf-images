#!/bin/bash
redis-server &> /var/log/redis.log & disown
exec bash
