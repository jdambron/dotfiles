command -q wl-paste && command -q wl-copy && command -q tesseract || return
function ocr-eng --wraps='wl-paste | tesseract -l eng stdin stdout | wl-copy' --description 'alias ocr-eng=wl-paste | tesseract -l eng stdin stdout | wl-copy'
  wl-paste | tesseract -l eng stdin stdout | wl-copy $argv
        
end
