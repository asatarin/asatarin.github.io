// Click-to-load YouTube and SpeakerDeck embeds, and transcript timecodes that seek the video.
// The placeholders are plain links, so without JavaScript they open YouTube / SpeakerDeck instead.
(function () {
  'use strict';

  var player = null;          // YT.Player, once the IFrame API is ready
  var pendingSeconds = null;  // seek requested while the API was still loading
  var apiRequested = false;

  function replaceWithIframe(placeholder, src, allow) {
    var iframe = document.createElement('iframe');
    iframe.src = src;
    iframe.title = placeholder.getAttribute('aria-label');
    iframe.allow = allow;
    iframe.allowFullscreen = true;
    placeholder.replaceWith(iframe);
    return iframe;
  }

  function loadVideo(placeholder, startSeconds) {
    var src = 'https://www.youtube.com/embed/' + placeholder.dataset.videoId + '?enablejsapi=1&autoplay=1';
    if (startSeconds) {
      src += '&start=' + startSeconds;
    }
    replaceWithIframe(placeholder, src, 'autoplay; encrypted-media; picture-in-picture; fullscreen').id = 'player';
    requestPlayerApi();
  }

  function requestPlayerApi() {
    if (apiRequested) {
      return;
    }
    apiRequested = true;
    window.onYouTubeIframeAPIReady = function () {
      new YT.Player('player', {
        events: {
          onReady: function (event) {
            player = event.target;
            if (pendingSeconds !== null) {
              seek(pendingSeconds);
            }
          }
        }
      });
    };
    var script = document.createElement('script');
    script.src = 'https://www.youtube.com/iframe_api';
    document.head.appendChild(script);
  }

  function seek(seconds) {
    if (player) {
      pendingSeconds = null;
      player.seekTo(seconds, true);
      player.playVideo();
      return;
    }
    var placeholder = document.querySelector('.video-placeholder');
    if (placeholder) {
      loadVideo(placeholder, seconds);  // the start parameter handles the first seek
    } else {
      pendingSeconds = seconds;
      requestPlayerApi();
    }
  }

  function loadSlides(placeholder) {
    var src = 'https://speakerdeck.com/player/' + placeholder.dataset.deckId + '?slide=' + placeholder.dataset.slide;
    replaceWithIframe(placeholder, src, 'fullscreen');
  }

  // "1:30" -> 90, "1:02:03" -> 3723
  function timeToSeconds(text) {
    return text.trim().split(':').reduce(function (total, part) {
      return total * 60 + parseInt(part, 10);
    }, 0);
  }

  document.addEventListener('click', function (event) {
    var target = event.target.closest('.video-placeholder, .slides-placeholder, .timecode');
    if (!target) {
      return;
    }
    if (target.classList.contains('timecode')) {
      seek(timeToSeconds(target.textContent));  // the enclosing #video link scrolls to the player
      return;
    }
    event.preventDefault();
    if (target.classList.contains('video-placeholder')) {
      loadVideo(target);
    } else {
      loadSlides(target);
    }
  });
})();
