#!/bin/bash

export MIX_ENV=prod
export PORT=4798

echo "Stopping old copy of app, if any..."

_build/prod/rel/stock_pile/bin/stock_pile stop || true

echo "Starting app..."

_build/prod/rel/stock_pile/bin/stock_pile foreground
