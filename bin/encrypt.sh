#!/bin/bash
rm .env.production.encrypted
base64 .env.production > .env.production.encrypted
