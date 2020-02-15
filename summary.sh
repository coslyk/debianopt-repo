#!/bin/sh

if [ -f "success.txt" ]; then
    echo "Successfully built:"
    cat success.txt
fi

if [ -f "failure.txt" ]; then
    echo ""
    echo "Failed to build:"
    cat failure.txt
    exit 1
fi

exit 0
