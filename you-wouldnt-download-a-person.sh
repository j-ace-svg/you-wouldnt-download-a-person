#!/bin/sh

# Make script fail if any individual commands fail
set -e

if [[ $# = 0 ]] || [[ "$1" = "-h" ]]; then
    if [[ $# = 0 ]]; then
      # App introduction
      echo "You wouldn't download a person - quickly download music from a youtube url"
      echo ""
    fi

    # Help menu
    echo "Usage: you-wouldnt-download-a-person [OPTIONS] URL [URL...]"
    echo ""
    echo "Options:"
    printf '%s\n' \
            "-h/Display this help text" \
            "-r/Download all songs from a channel's releases page" \
            "-a/Download a single album from within an artist's folder" \
            "-s/Download a single song to an artist's folder" \
            | column -t -s "/"
    exit 0
fi

if [ "$1" = "-s" ]; then
    shift
    yt-dlp -xo "%(title)s.%(ext)s" "$1"
fi

if [ "$1" = "-a" ]; then
    shift
    yt-dlp -xo "%(playlist_title)s/%(playlist_index)s %(title)s.%(ext)s" "$1"
fi

if [ "$1" = "-r" ]; then
    shift
    while [[ $# != 0 ]]; do
        channel="$(yt-dlp --print channel "$1")"
        echo "$channel"
        mkdir "$channel"
        pushd "$channel"
        yt-dlp -xo "%(channel)s/%(playlist_title)s/%(playlist_index)s %(title)s.%(ext)s" "$1"
        shift
        popd
    done

    exit 0
fi
