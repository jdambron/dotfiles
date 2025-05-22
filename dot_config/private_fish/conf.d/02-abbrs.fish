# Section: Help and Display
abbr -a --position anywhere --set-cursor -- -h "-h 2>&1 | bat --plain --language=help"

# Section: File and Directory Management
abbr mkdir "mkdir -vp"
abbr rc "rsync -rauv --progress"

# Section: Editor
if command -q nvim
    abbr vim nvim
    abbr vi nvim
    abbr v nvim
end
if command -q helix
    abbr hx helix
end

# Section: Download and Upload
if command -q aria2c
    abbr a2 "aria2c --seed-time=0 --file-allocation=none"
end

# Section: Utilities
abbr l ll
abbr lg lazygit
abbr sv sudoedit
abbr vudo sudoedit

# Section: Weather
abbr meteo "curl -s wttr.in | rg -v Follow"

# Section: OCR
abbr ocr-eng "wl-paste | tesseract -l eng stdin stdout | wl-copy"
abbr ocr-fra "wl-paste | tesseract -l fra stdin stdout | wl-copy"

# Section: System Management
# systemctl
abbr s systemctl
abbr su "systemctl --user"
abbr ss "command systemctl status"
abbr sl "systemctl --type service --state running"
abbr slu "systemctl --user --type service --state running"
abbr se "sudo systemctl enable --now"
abbr sd "sudo systemctl disable --now"
abbr sr "sudo systemctl restart"
abbr so "sudo systemctl stop"
abbr sa "sudo systemctl start"
abbr sf "systemctl --failed --all"

# journalctl
abbr jb "journalctl -b"
abbr jf "journalctl --follow"
abbr jg "journalctl -b --grep"
abbr ju "journalctl --unit"

# Section: Package Management
abbr p paru
abbr pai "paru -S"
abbr par "paru -Rns"
abbr pas "paru -Ss"
abbr pal "paru -Q"
abbr paf "paru -Ql"
abbr pao "paru -Qo"

# Section : git
abbr ga "git add"
abbr gaa "git add -A"
abbr gc "git commit"
abbr gco "git checkout"
abbr gd "git diff"
abbr gdc "git diff --cached"
abbr gp "git push"
abbr gs "git status"
abbr gt "git tag"

# Section : bun
abbr bu "bun update"
abbr bus "bun upgrade --stable"
abbr bo "bun outdated"
