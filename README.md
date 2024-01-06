# YT-to-VLC
Small bash/batch tool that automates the process of playing videos from YouTube and other sites in VLC media player through yt-dlp

## Details
The script's goal is to provide an easy way of watching YouTube videos without distractions, directly from VLC media player. Despite VLC being able to do this on its own, its feature does not update as often and ends up breaking. To fix this problem, this script uses [yt-dlp](https://github.com/yt-dlp/yt-dlp) to do the work, since it updates regularly.

This script is made with less advanced users in mind. Tech savvy users normally use programs like [MPV](https://github.com/mpv-player/mpv) to watch YouTube, since it natively supports yt-dlp. Although there are great lightweight and intuitive frontends for MPV like [SMPlayer](https://github.com/smplayer-dev/smplayer) and [Celluloid](https://github.com/celluloid-player/celluloid), users shouldn't need to change their favorite media player to watch YouTube videos with the same experience MPV users have.

## Features
* Simple, efficient and lightweight
* Automatically download and install yt-dlp updates
* Supports YouTube and [all other sites supported by yt-dlp](https://github.com/yt-dlp/yt-dlp/blob/master/supportedsites.md)
* Allows the user to select a specific video resolution
* Works with regular videos
* Can be used to open videos directly from the web browser

## Web browser integration
With the package, there's a .reg file. Edit it with Notepad (or your favorite text editor) and replace the last line with the path to the directory you stored YT-to-VLC. Save and merge it. Follow the example below:

`@="\"C:\\yt-to-vlc\\yt-to-vlc.bat\" %1"`

Now, use the [Redirector](https://github.com/einaregilsson/Redirector) extension ([Chrome-based browsers](https://chromewebstore.google.com/detail/redirector/ocgpenflpmgnfapjedencafcfakcekcd), [Edge](https://microsoftedge.microsoft.com/addons/detail/redirector/jdhdjbcalnfbmfdpfggcogaegfcjdcfp), [Firefox](https://addons.mozilla.org/firefox/addon/redirector)) to create the following rules:

**Rule 1:** YouTube videos  
**Example URL:** `https://www.youtube.com/watch?v=`  
**Include pattern:** `https://www.youtube.com/watch?v=*`  
**Redirect to:** `yttovlc://http://youtu.be/$1`  
**Advanced options, Apply to:** check every box

**Rule 2:** YouTube Shorts  
**Example URL:** `https://www.youtube.com/shorts/`  
**Include pattern:** `https://www.youtube.com/shorts/*`  
**Redirect to:** `yttovlc://http://youtu.be/$1`  
**Advanced options, Apply to:** check every box

After that, you're ready.

## To-do
- [ ] Create bash version for Linux distros
- [ ] Find a way to play videos in resolutions higher than 720p

## Contribute
* Report bugs and suggest improvements through Issues, Pull Requests and Discussions
* Translate the script to other languages through Pull Requests
