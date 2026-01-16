
$files = Get-ChildItem "e:\InclamUpdate\InclamWebsite\*.html" 

$cssContent = @'
    <!-- updated CSS for video player By Akashkumbhar Jan2026 -->
    <style>
        /* PLAYER */
        .player {
            margin: auto;
            background-color: #16151a;
            border-radius: 12px;
            transition: all 0.5s ease;
            padding: 5px;
            height: 0;
        }

        #ytPlayer {
            width: 100%;
            height: fit-content;
            /* VIDEO HEIGHT */
            display: block;
            border-radius: 12px;
        }

        .player_openclose_btn {
            position: absolute;
            top: -30px;
            left: 50%;
            transform: translateX(-50%);
            display: flex;
            flex-direction: row;
            justify-content: center;
            align-items: center;
            background-color: #16151a;
            border-radius: 12px 12px 0 0;
            height: 40px;
            width: 90px;
            color: #fff;
            font-size: 14px;
            border: 1px solid #222227;
            border-bottom: none;
        }

        .player.player--open {
            transform: translateY(0);
            /* JS will control real height */
            border: 1px solid #25a5699a;
            padding: 16px;
            transition: all 0.5s ease;
            box-shadow: -2px -3px 10px rgba(37, 165, 106, 0.5);
        }

        .player.player--open .player_openclose_btn {
            border: 1px solid #25a5699a;
            border-bottom: none;
            box-shadow: -2px -4px 10px rgba(37, 165, 106, 0.5);
        }

        .player_openclose_btn svg {
            fill: #25a56a;
            width: 18px;
            margin-right: 10px;
        }
    </style>
'@

$jsContent = @'
    <!-- updated js for video player By Akashkumbhar Jan2026 -->
    <script>
        const ytPlayer = document.getElementById("ytPlayer");
        const playerTitle = document.getElementById("playerTitle");
        const playerArtist = document.getElementById("playerArtist");
        const playerCover = document.getElementById("playerCover");

        document.querySelectorAll(".yt-item").forEach(item => {
            item.addEventListener("click", () => {

                /* ✅ CHECK STATE FIRST */
                const isActive = item.classList.contains("active");
                const isPlaying = item.classList.contains("play");

                /* reset all items */
                document.querySelectorAll(".yt-item").forEach(el => {
                    el.classList.remove("active", "play", "pause");
                });

                /* same item clicked again → pause UI only */
                if (isActive && isPlaying) {
                    item.classList.add("active", "pause");
                    return;
                }

                /* play state */
                item.classList.add("active", "play");

                ytPlayer.src =
                    "https://www.youtube.com/embed/" +
                    item.dataset.videoId +
                    "?autoplay=1&rel=0";

                playerTitle.textContent = item.dataset.title;
                playerArtist.textContent = item.dataset.artist;

                openPlayer();
            });
        });

        /* ======================
           PLAYER OPEN / CLOSE
        ====================== */

        const player = document.querySelector(".player");
        const toggleBtn = document.querySelector(".player_openclose_btn");

        let isOpen = false;

        function openPlayer() {
            if (isOpen) return;

            player.classList.add("player--open");
            player.style.height = player.scrollHeight + "px";
            isOpen = true;
        }

        function closePlayer() {
            player.style.height = player.scrollHeight + "px";

            requestAnimationFrame(() => {
                player.style.height = "0px";
            });

            player.classList.remove("player--open");
            isOpen = false;
        }

        /* toggle on button click */
        toggleBtn.addEventListener("click", () => {
            isOpen ? closePlayer() : openPlayer();
        });

        /* after open animation → allow auto height */
        player.addEventListener("transitionend", () => {
            if (isOpen) {
                player.style.height = "auto";
            }
        });
    </script>
'@

foreach ($file in $files) {
    try {
        $content = Get-Content $file.FullName -Raw
        
        # Identify if content is missing
        if ($content -match "updated CSS for video player By Akashkumbhar Jan2026") {
            item
            Write-Host "Skipping $($file.Name) (Already updated)"
            continue
        }

        Write-Host "Updating $($file.Name)..."
        
        # Replace </head>
        $content = $content -replace "<\/head>", "$cssContent`n</head>"
        
        # Replace </body>
        $content = $content -replace "<\/body>", "$jsContent`n</body>"
        
        Set-Content -Path $file.FullName -Value $content -Encoding UTF8
    } catch {
        Write-Error "Error processing $($file.Name): $_"
    }
}
