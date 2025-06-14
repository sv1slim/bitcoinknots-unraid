#!/bin/bash

# Start backend
pm2 start /mempool/backend/index.js --name mempool-backend

# Start frontend (static files with serve)
npm install -g serve
pm2 start "serve -s /mempool/frontend/dist -l 8080" --name mempool-frontend

# Keep container alive
pm2 logs
