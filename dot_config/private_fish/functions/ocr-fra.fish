command -q wl-paste && command -q wl-copy && command -q tesseract || return
function ocr-fra --wraps='wl-paste | tesseract -l fra stdin stdout | wl-copy' --description 'alias ocr-fra=wl-paste | tesseract -l fra stdin stdout | wl-copy'
  wl-paste | tesseract -l fra stdin stdout | wl-copy $argv
        
end
