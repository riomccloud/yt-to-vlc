# YT-to-VLC
Small bash/batch tool that automates the process of playing videos from YouTube and other sites in VLC media player through yt-dlp

## Details
The script's goal is to provide an easy way of watching YouTube videos without distractions, directly from VLC media player. Despite VLC being able to do this on its own, its feature does not update as often and ends up breaking. To fix this problem, this script uses [yt-dlp](https://github.com/yt-dlp/yt-dlp) to do the work, since it updates regularly.

This script is made with less advanced users in mind. Tech savvy users normally use programs like [MPV](https://github.com/mpv-player/mpv) to watch YouTube, since it natively supports yt-dlp. Although there are great lightweight and intuitive frontends for MPV like [SMPlayer](https://github.com/smplayer-dev/smplayer) and [Celluloid](https://github.com/celluloid-player/celluloid), users shouldn't need to change their favorite media player to watch YouTube videos with the same experience MPV users have.

## Features
* Simple, efficient and lightweight
* Translations to various languages (help appreciated!)
* Automatically download and install yt-dlp updates
* Supports YouTube and [all other sites supported by yt-dlp](https://github.com/yt-dlp/yt-dlp/blob/master/supportedsites.md)
* Allows the user to select a specific video resolution
* Works with regular videos and livestreams

## To-do
- [ ] Create bash version for Linux distros

## Contribute
* Report bugs and suggest improvements through Issues, Pull Requests and Discussions
* Translate the script to other languages through Pull Requests
